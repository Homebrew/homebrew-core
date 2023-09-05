class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V2.3.1_src.zip"
  sha256 "bd0bcf58cec284824b79ff55baa242903ed361e12b1b37e12228679f9754961c"
  license "AGPL-3.0-only"
  revision 2

  livecheck do
    url "https://www.argyllcms.com/downloadsrc.html"
    regex(/href=.*?Argyll[._-]v?(\d+(?:\.\d+)+)[._-]src\.zip/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ad35dcd73ff37d15df2b15987a5f79c5b7f41162a9ee42da8f584cac54064a4"
    sha256 cellar: :any,                 arm64_monterey: "ef4aff5c9c30f8eb6fcb636eb12a5dbe3cb60ccf505b30e774a3aa5a30469e7e"
    sha256 cellar: :any,                 arm64_big_sur:  "d5f7c5c9c7f4fca8fd7af2727ac552bb35e06ebe2f13245da69bc27cb6a4d9e7"
    sha256 cellar: :any,                 ventura:        "c7ebeb7d9e4c04a0fd084be13c60096b835f6bbf5542569d8bf0e3cdb973604b"
    sha256 cellar: :any,                 monterey:       "ff74541a571f54ee365a65ff561ac2306838c84d184409b3739e0196a4cb8b42"
    sha256 cellar: :any,                 big_sur:        "f028044af8ff1a5cbb4bc1790e71dcd57ed42c55502b2f3ab02e6e91e9c05fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bee4ce2f70e61cba9cf09688157135cbd7672c5558877e29bfbc7fe7ade7907"
  end

  depends_on "jam" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "xorgproto"
  end

  conflicts_with "num-utils", because: "both install `average` binaries"

  # Fixes a missing header, which is an error by default on arm64 but not x86_64
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f6ede0dff06c2d9e3383416dc57c5157704b6f3a/argyll-cms/unistd_import.diff"
    sha256 "5ce1e66daf86bcd43a0d2a14181b5e04574757bcbf21c5f27b1f1d22f82a8a6e"
  end

  def install
    # Remove bundled libraries to prevent fallback
    %w[jpeg png tiff zlib].each { |l| (buildpath/l).rmtree }

    inreplace "Jamtop" do |s|
      openssl = Formula["openssl@3"]
      libname = shared_library("lib$(lcase)")

      # These two inreplaces make sure all Homebrew and SDK libraries can be found by the Jamfile
      s.gsub! "[ GLOB /usr/include$(subd) : $(lcase).h $(lcase)lib.h ]",
              "[ GLOB #{openssl.opt_include}$(subd) : $(lcase).h $(lcase)lib.h ] || " \
              "[ GLOB #{HOMEBREW_PREFIX}/include$(subd) : $(lcase).h $(lcase)lib.h ] || " \
              "[ GLOB #{MacOS.sdk_path_if_needed}/usr/include$(subd) : $(lcase).h $(lcase)lib.h ]"
      s.gsub! "[ GLOB /usr/lib : lib$(lcase).so ]",
              "[ GLOB #{openssl.opt_lib} : #{libname} ] || " \
              "[ GLOB #{HOMEBREW_PREFIX}/lib : #{libname} ] || " \
              "[ GLOB #{MacOS.sdk_path_if_needed}/usr/lib : #{libname} lib$(lcase).tbd ]"

      # These two inreplaces make sure the X11 headers can be found on Linux.
      s.gsub! "/usr/X11R6/include", HOMEBREW_PREFIX/"include"
      s.gsub! "/usr/X11R6/lib", HOMEBREW_PREFIX/"lib"
    end

    ENV["NUMBER_OF_PROCESSORS"] = ENV.make_jobs.to_s
    system "sh", "makeall.sh"
    system "./makeinstall.sh"
    rm "bin/License.txt"
    prefix.install "bin", "ref", "doc"
  end

  test do
    system bin/"targen", "-d", "0", "test.ti1"
    system bin/"printtarg", testpath/"test.ti1"
    %w[test.ti1.ps test.ti1.ti1 test.ti1.ti2].each do |f|
      assert_predicate testpath/f, :exist?
    end

    # Skip this part of the test on Linux because it hangs due to lack of a display.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Calibrate a Display", shell_output("#{bin}/dispcal 2>&1", 1)
  end
end
