class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V2.2.1_src.zip"
  sha256 "24cbef0e81a7ce8424957cbcb399cdea2f069f64866536d181e879ce1ed18ff8"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.argyllcms.com/downloadsrc.html"
    regex(/href=.*?Argyll[._-]v?(\d+(?:\.\d+)+)[._-]src\.zip/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "9847a3b7f40b2a075b10926264fd60abd6fe38023394aee9338548e36f88bc98"
    sha256 cellar: :any, arm64_big_sur:  "cd01b34b8340af770348c75ba24f241c4165a343fd470e9104ce6680f9a67987"
    sha256 cellar: :any, monterey:       "1048438b7f241d538952346e4e2f145a52743149f436cdf0b9f7c644dcf1a2f8"
    sha256 cellar: :any, big_sur:        "23d23cf1ec9dd7d5d128ac055031a7dadfe60942cb013b90d40922dfec564ea8"
    sha256 cellar: :any, catalina:       "48ad5563ffb6bdb54671d4e11605a14963c5c0a82e632c710e97086f650b0ae1"
    sha256 cellar: :any, mojave:         "198c516d829ff22b66f948768ec5841228e002ed840f647a799aab79b202657f"
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
