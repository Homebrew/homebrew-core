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
    sha256 cellar: :any,                 arm64_monterey: "2eb28a59cef2bdcc142008d4d36470e586e8e22285273303802a7e16bb95d08f"
    sha256 cellar: :any,                 arm64_big_sur:  "253c5434082b4237f8067ad31ee6fae81811048f76d2cad8e2ae3ca360d51be8"
    sha256 cellar: :any,                 monterey:       "efa97d39822d0ded97541bc095e59a976eb3f893da6bd4cbb2a90a3174cd9830"
    sha256 cellar: :any,                 big_sur:        "eb7a9fd709675ccd7f1b59ae9d3e17bc301b4f7c15857a4c32f8f71e6801dc05"
    sha256 cellar: :any,                 catalina:       "36860658ac2513441fcf1968c16d57fa6fbb5b7385d5437df24ffebe84ed7e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f4ed53c2d490076f96e3833f36d35c8629f909eba688142349489138856037c"
  end

  depends_on "jam" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

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
    # These two inreplaces make sure /opt/homebrew can be found by the
    # Jamfile, which otherwise fails to locate system libraries
    inreplace "Jamtop", "/usr/include/x86_64-linux-gnu$(subd)", "#{HOMEBREW_PREFIX}/include$(subd)"
    inreplace "Jamtop", "/usr/lib/x86_64-linux-gnu", "#{HOMEBREW_PREFIX}/lib"
    # These two inreplaces make sure the X11 headers can be found on Linux.
    unless OS.mac?
      inreplace "Jamtop", "/usr/X11R6/include", HOMEBREW_PREFIX/"include"
      inreplace "Jamtop", "/usr/X11R6/lib", HOMEBREW_PREFIX/"lib"
    end
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
