class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  # TODO: Remove `ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib` at rebuild.
  url "https://github.com/GrokImageCompression/grok/archive/v9.7.1.tar.gz"
  sha256 "a7d433dca92b035349ef8203eb44cb6d0b2c9b41aecd2d12872a9ca2761e0606"
  license "AGPL-3.0-or-later"
  revision 2
  head "https://github.com/GrokImageCompression/grok.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "f278c89c6747a0701b038b6c6c4cf924f2e320a6e398d8d638261e56a6a7ed5e"
    sha256 cellar: :any,                 arm64_big_sur:  "5275d16ed57d86e7693149ea36d833ba0669e799e2759fa66d3c706ca4deb0b3"
    sha256 cellar: :any,                 monterey:       "848f7f689ce0da957c6679b704c4a92d367955b82b71a4599ecfffb730c7dc8a"
    sha256 cellar: :any,                 big_sur:        "778b6446451ce7d8b423564975ad3ef5e1d6804259ddd36dd8a109c9400bca72"
    sha256 cellar: :any,                 catalina:       "bc1ebffbbc30c624050661ff22a14317b91e2afb728e820131c2986232f06690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "115d7a94a7288ba4933a95683814f1f2684f1b9405a356bad3267c8504bdf25c"
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
    # HACK: this should not be a test dependency but is due to a limitation with fails_with
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version >= 1205
  end

  # https://github.com/GrokImageCompression/grok/blob/master/INSTALL.md#compilers
  fails_with :gcc do
    version "9"
    cause "GNU compiler version must be at least 10.0"
  end

  # Build failed with Apple clang version 12.0.5 and 13.0.0.
  # clang: error: unable to execute command: Segmentation fault: 11
  # clang: error: clang frontend command failed due to signal (use -v to see invocation)
  # Upstream issue closed as Apple clang bug: https://github.com/GrokImageCompression/grok/issues/256
  fails_with :clang if DevelopmentTools.clang_build_version >= 1205

  resource "test_image" do
    url "https://raw.githubusercontent.com/GrokImageCompression/input_image_test_suite/173de0ae73371751f857d16fdaf2c3301e54a3a6/exif-samples/tiff/Tless0.tiff"
    sha256 "32f6aab90dc2d284a83040debe379e01333107b83a98c1aa2e6dabf56790b48a"
  end

  def install
    args = ["-DBUILD_DOC=ON"]

    if DevelopmentTools.clang_build_version >= 1205
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
      ENV.llvm_clang
      # Workaround issue with LLVM install_name_tool, which causes errors during install.
      # .../llvm/bin/install_name_tool: error: unsupported load command (cmd=0x80000034)
      args << "-DCMAKE_INSTALL_NAME_TOOL=/usr/bin/install_name_tool"
    end

    # Fix: ExifTool Perl module not found
    ENV.prepend_path "PERL5LIB", Formula["exiftool"].opt_libexec/"lib"

    # Ensure we use Homebrew little-cms2
    inreplace "thirdparty/CMakeLists.txt" do |s|
      s.gsub! "add_subdirectory(liblcms2)", ""
      s.gsub! %r{(set\(LCMS_INCLUDE_DIRNAME) \$\{GROK_SOURCE_DIR\}/thirdparty/liblcms2/include},
              "\\1 #{Formula["little-cms2"].opt_include}"
    end

    # Workaround to fix build when using Homebrew little-cms2 headers with C++17.
    # lcms2.h:1279:44: error: ISO C++17 does not allow 'register' storage class specifier
    # See https://github.com/GrokImageCompression/grok/issues/241
    ENV.append "CXXFLAGS", "-DCMS_NO_REGISTER_KEYWORD=1"

    perl = DevelopmentTools.locate("perl")
    if OS.mac?
      # Workaround Perl 5.18 issues with C++11: pad.h:323:17: error: invalid suffix on literal
      ENV.append "CXXFLAGS", "-Wno-reserved-user-defined-literal" if MacOS.version <= :catalina
      # Help CMake find Perl libraries, which are needed to enable ExifTool feature.
      # Without this, CMake outputs: Could NOT find PerlLibs (missing: PERL_INCLUDE_PATH)
      perl_path = MacOS.sdk_path/"System/Library/Perl"/MacOS.preferred_perl_version
      args << "-DPERL_INCLUDE_PATH=#{perl_path}/darwin-thread-multi-2level/CORE"
      args << "-DPERL_EXECUTABLE=#{perl}"
    else
      # Fix linkage error due to RPATH missing directory with libperl.so
      perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
      ENV.append "LDFLAGS", "-Wl,-rpath,#{perl_archlib}/CORE"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install_symlink "grok-#{version.major_minor}" => "grok"

    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"]
  end

  test do
    # Force use of Clang on macOS 11+
    ENV.clang if DevelopmentTools.clang_build_version >= 1205

    (testpath/"test.c").write <<~EOS
      #include <grok/grok.h>

      int main () {
        grk_image_comp cmptparm;
        const GRK_COLOR_SPACE color_space = GRK_CLRSPC_GRAY;

        grk_image *image;
        image = grk_image_new(1, &cmptparm, color_space);

        grk_object_unref(&image->obj);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgrokj2k", "-o", "test"
    system "./test"

    # Test Exif metadata retrieval
    resource("test_image").stage do
      system bin/"grk_compress", "-InputFile", "Tless0.tiff",
                                 "-OutputFile", "test.jp2", "-OutFor", "jp2",
                                 "-TransferExifTags"
      output = shell_output("#{Formula["exiftool"].bin}/exiftool test.jp2")

      [
        "Exif Byte Order                 : Big-endian (Motorola, MM)",
        "Orientation                     : Horizontal (normal)",
        "X Resolution                    : 72",
        "Y Resolution                    : 72",
        "Resolution Unit                 : inches",
        "Y Cb Cr Positioning             : Centered",
      ].each do |data|
        assert_match data, output
      end
    end
  end
end
