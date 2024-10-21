class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  # pull from git tag to get submodules
  url "https://github.com/GrokImageCompression/grok.git",
      tag:      "v13.0.1",
      revision: "4b1049297bfb93a0f2afbe598f4dab92545ee1ad"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "910f7814e8a277f91e2025d3ce63ef893a0c510258b66b1f959e6c92adef49e8"
    sha256 cellar: :any,                 arm64_sonoma:  "79d6aa802e6bbd05f9419aa0e4e4b1a3983726512950807622ce6bcee03b44ac"
    sha256 cellar: :any,                 arm64_ventura: "6d8a3a6279986948e768e01ab5ea2664c57e4ddab9223dc020edbff1b2395b34"
    sha256 cellar: :any,                 sonoma:        "7e673d821b739675a709a6f20920b7bf290f3c5c5993b7c5416218c6decb6f90"
    sha256 cellar: :any,                 ventura:       "1652e8c9704c3cf12ba9ab4433f0db3654ca3430d21b8eee0bf22ee1f5600c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4856d40704907d83ffad6b465f99613fbde60592abdb215dfc65f851ecd5808"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "exiftool"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on macos: :catalina

  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1200
    depends_on "xz"
    depends_on "zstd"
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  # https://github.com/GrokImageCompression/grok/blob/master/INSTALL.md#compilers
  fails_with :gcc do
    version "9"
    cause "GNU compiler version must be at least 10.0"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)

    # Fix: ExifTool Perl module not found
    ENV.prepend_path "PERL5LIB", Formula["exiftool"].opt_libexec/"lib"

    # Ensure we use Homebrew little-cms2
    %w[liblcms2 libpng libtiff libz].each { |l| rm_r(buildpath/"thirdparty"/l) }
    inreplace "thirdparty/CMakeLists.txt" do |s|
      s.gsub! "add_subdirectory(liblcms2)", ""
      s.gsub! %r{(set\(LCMS_INCLUDE_DIRNAME) \$\{GROK_SOURCE_DIR\}/thirdparty/liblcms2/include},
              "\\1 #{Formula["little-cms2"].opt_include}"
    end

    perl = DevelopmentTools.locate("perl")
    perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
    args = %W[
      -DGRK_BUILD_DOC=ON
      -DGRK_BUILD_LIBPNG=OFF
      -DGRK_BUILD_LIBTIFF=OFF
      -DPERL_EXECUTABLE=#{perl}
    ]

    if OS.mac?
      # Workaround Perl 5.18 issues with C++11: pad.h:323:17: error: invalid suffix on literal
      ENV.append "CXXFLAGS", "-Wno-reserved-user-defined-literal" if MacOS.version <= :catalina
      # Help CMake find Perl libraries, which are needed to enable ExifTool feature.
      # Without this, CMake outputs: Could NOT find PerlLibs (missing: PERL_INCLUDE_PATH)
      args << "-DPERL_INCLUDE_PATH=#{MacOS.sdk_path_if_needed}/#{perl_archlib}/CORE"
    else
      # Fix linkage error due to RPATH missing directory with libperl.so
      ENV.append "LDFLAGS", "-Wl,-rpath,#{perl_archlib}/CORE"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install_symlink "grok-#{version.major_minor}" => "grok"

    bin.env_script_all_files libexec, PERL5LIB: ENV["PERL5LIB"]
  end

  test do
    resource "homebrew-test_image" do
      url "https://github.com/GrokImageCompression/grok-test-data/raw/43ce4cb/input/nonregression/pngsuite/basn0g01.png"
      sha256 "c23c1848002082e128f533dc3c24a49fc57329293cc1468cc9dc36339b1abcac"
    end

    (testpath/"test.c").write <<~EOS
      #include <grok/grok.h>

      int main () {
        grk_image_comp cmptparm;
        const GRK_COLOR_SPACE color_space = GRK_CLRSPC_GRAY;

        grk_image *image;
        image = grk_image_new(1, &cmptparm, color_space, true);

        grk_object_unref(&image->obj);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgrokj2k", "-o", "test"
    system "./test"

    # Test Exif metadata retrieval
    testpath.install resource("homebrew-test_image")
    system bin/"grk_compress", "--in-file", "basn0g01.png",
                                "--out-file", "test.jp2", "--out-fmt", "jp2",
                                "--transfer-exif-tags"
    output = shell_output("#{Formula["exiftool"].bin}/exiftool test.jp2")

    expected_fields = [
      "File Type                       : JP2",
      "MIME Type                       : image/jp2",
      "Major Brand                     : JPEG 2000 Image (.JP2)",
      "Compatible Brands               : jp2",
      "Image Height                    : 32",
      "Image Width                     : 32",
      "Bits Per Component              : 1 Bits, Unsigned",
      "Compression                     : JPEG 2000",
    ]

    expected_fields.each do |field|
      assert_match field, output
    end
  end
end
