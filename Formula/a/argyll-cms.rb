class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V2.3.1_src.zip"
  sha256 "bd0bcf58cec284824b79ff55baa242903ed361e12b1b37e12228679f9754961c"
  license "AGPL-3.0-only"
  revision 1

  livecheck do
    url "https://www.argyllcms.com/downloadsrc.html"
    regex(/href=.*?Argyll[._-]v?(\d+(?:\.\d+)+)[._-]src\.zip/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a5fcde403ff9fcd5066e618d9881746cd74497673cb45b5b70513dd7eed2e4e5"
    sha256 cellar: :any,                 arm64_monterey: "b984e5dad0d132169e324c0ce6e2247a3215978ffab873389c076e3d4329dd0a"
    sha256 cellar: :any,                 arm64_big_sur:  "7da00534b2a37d605ad48b5040f5c3963ab34e4e532aa8e141cb06bc8b95a3de"
    sha256 cellar: :any,                 ventura:        "82a1932941c85b76d58c00161b08778a67adf2f79c17d62022b43f50e12f6f38"
    sha256 cellar: :any,                 monterey:       "046626e1817bfb96c4c5bd57eca3e5fb431c468280ca2719826f761980211c80"
    sha256 cellar: :any,                 big_sur:        "7b6bb889e77f4f01c17dd64e8c99170b5e7b00248d4701459d01c14f1fbf47e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85d4cb96a1cb7f85063ef58ba270e68c55e9dedd2d6ab5807acc0946d549ca6a"
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
