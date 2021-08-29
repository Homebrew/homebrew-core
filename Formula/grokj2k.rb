class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://github.com/GrokImageCompression/grok/archive/v9.4.0.tar.gz"
  sha256 "4a41c6801591539041d253dc8a58c0503b2976baf38ab9ce2a2571a3af461aaf"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0ff80b270e775a3f3e8e5711358293e1360430a3277b0a69b20eb6522e61e0a0"
    sha256 cellar: :any, big_sur:       "bb8a5620f4b6102088251cdaa9aa991d0fec06c9b9482fd2aa4a8232eb5afd95"
    sha256 cellar: :any, catalina:      "32efd38b670868596e67fe8c8b0649318acc83644d55452a088687e9676a5c7d"
    sha256 cellar: :any, mojave:        "028c9c864189cb90f43c422ba74f60c2297bb427f238713780c20a88adffc5c3"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "exiftool"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version == 1205
  end

  on_linux do
    depends_on "gcc"
  end

  # https://github.com/GrokImageCompression/grok/blob/master/INSTALL.md#compilers
  fails_with :gcc do
    version "9"
    cause "GNU compiler version must be at least 10.0"
  end

  # clang: error: clang frontend command failed due to signal (use -v to see invocation)
  # Apple clang version 12.0.5 (clang-1205.0.22.9)
  # Upstream issue closed as Apple clang bug: https://github.com/GrokImageCompression/grok/issues/256
  fails_with :clang if DevelopmentTools.clang_build_version == 1205

  resource "test_image" do
    url "https://github.com/GrokImageCompression/grok-compression-input-images/raw/173de0ae73371751f857d16fdaf2c3301e54a3a6/exif-samples/tiff/Tless0.tiff"
    sha256 "32f6aab90dc2d284a83040debe379e01333107b83a98c1aa2e6dabf56790b48a"
  end

  def install
    if DevelopmentTools.clang_build_version == 1205
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
      ENV.llvm_clang
    end

    ENV.prepend_path "PERL5LIB", Formula["exiftool"].opt_libexec/"lib"

    cmake_args = std_cmake_args + ["-DBUILD_DOC=ON"]
    if OS.mac?
      # Help CMake find Perl libraries, which are needed to enable ExifTool feature.
      # Without this, it outputs: Could NOT find PerlLibs (missing: PERL_INCLUDE_PATH)
      perl_path = MacOS.sdk_path/"System/Library/Perl"/MacOS.preferred_perl_version
      cmake_args << "-DPERL_INCLUDE_PATH=#{perl_path}/darwin-thread-multi-2level/CORE"
    else
      # Fix linkage error due to RPATH missing directory with libperl.so
      perl_path = Formula["perl"].opt_lib/"perl5"/Formula["perl"].version.major_minor
      ENV.append "LDFLAGS", "-Wl,-rpath=#{perl_path}/x86_64-linux-thread-multi/CORE"
    end

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
      include.install_symlink "grok-#{version.major_minor}" => "grok"
    end

    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"]
  end

  test do
    # Force use of Clang on Big Sur
    ENV.clang if DevelopmentTools.clang_build_version == 1205

    (testpath/"test.c").write <<~EOS
      #include <grok/grok.h>

      int main () {
        grk_image_cmptparm cmptparm;
        const GRK_COLOR_SPACE color_space = GRK_CLRSPC_GRAY;

        grk_image *image;
        image = grk_image_new(1, &cmptparm, color_space,false);

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
