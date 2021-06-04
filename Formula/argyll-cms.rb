class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V2.2.0_src.zip"
  sha256 "c612a2e49fd51e089616cd27b6d4717d0f20fc8edbd906462f0d0dbbabbc711c"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.argyllcms.com/downloadsrc.html"
    regex(/href=.*?Argyll[._-]v?(\d+(?:\.\d+)+)[._-]src\.zip/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3ae919d00b2a8977c21692d8b5a473982085a05a5718f9f15fa8647f2111362a"
    sha256 cellar: :any, big_sur:       "a33f069f86d63448d1f2b8d04465ea84d902300a1ecb656cbf0808a3b8776791"
    sha256 cellar: :any, catalina:      "d7fd1d597134461887b6477b4460fcc8fb2143d9c97e49b5dcc7ecf53758fe9a"
    sha256 cellar: :any, mojave:        "941603de5eacbc65d306339aef0c955cf111679247b710fa8c099ffe82ea5db4"
  end

  depends_on "jam" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

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
    assert_match "Calibrate a Display", shell_output("#{bin}/dispcal 2>&1", 1)
  end
end
