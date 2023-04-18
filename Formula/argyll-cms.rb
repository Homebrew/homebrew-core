class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V2.3.1_src.zip"
  sha256 "bd0bcf58cec284824b79ff55baa242903ed361e12b1b37e12228679f9754961c"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.argyllcms.com/downloadsrc.html"
    regex(/href=.*?Argyll[._-]v?(\d+(?:\.\d+)+)[._-]src\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "30fcd5d782e74fffb37d639ae30449062cfb8e5b68f500302f53eea98e972e3d"
    sha256 cellar: :any,                 arm64_monterey: "ab77de0d5218e45c5b9b2c6190f9c08ed53aac2aafb7c23bbcdbd05faf21a8d1"
    sha256 cellar: :any,                 arm64_big_sur:  "d2de7810f54558d2e12d566274d1a25075c085d21f357d30dcd6be18ea94a36e"
    sha256 cellar: :any,                 ventura:        "dc567e1d7c8ac4ccff0d021a1bfd835daa9024f0297b884535b7d25fe03e7ffe"
    sha256 cellar: :any,                 monterey:       "f4baba7347d52020f7e68fd90fadca1337c049abe047315550353556054123b7"
    sha256 cellar: :any,                 big_sur:        "b9a0b4117a777707a229636875d1d5785dc2a956f5748f4aaaded89855012ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "605fd5a5d79d3c5c1a33342a808a174bdd4add73c13036bb216c3e115a396b12"
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
