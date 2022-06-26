class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V2.3.0_src.zip"
  sha256 "daa21b6de8e20b5319a10ea8f72829d32eadae14c6581b50972f2f8dd5cde924"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.argyllcms.com/downloadsrc.html"
    regex(/href=.*?Argyll[._-]v?(\d+(?:\.\d+)+)[._-]src\.zip/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f7ef8b6684a81686d1eba6350d6a1dce78e0995264ab2dec383547c32042ab80"
    sha256 cellar: :any,                 arm64_big_sur:  "f19205f7c0d87399c06af8f2c905811f4cf101cf3f86e5d426e2afaeeef9f49b"
    sha256 cellar: :any,                 monterey:       "03feaa99b2fd77fdf1858b6596e0274595adcc126bb1070119b1e7830195dd33"
    sha256 cellar: :any,                 big_sur:        "69be49eb52ff6525015295bdcfb93e79c63dc89e79da072db2126f9e9ed7cec3"
    sha256 cellar: :any,                 catalina:       "236467588e60d2266690f20b319d892b19addaad6037a2dbc017fd1473baa0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32290105011f95d383046c0a656c9dd4328b3527dd4683f271eb1a341745fe75"
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
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Aug 2017 to graeme AT argyllcms DOT com
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "numlib/numsup.c", "CLOCK_MONOTONIC", "UNDEFINED_GIBBERISH"
    end

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
