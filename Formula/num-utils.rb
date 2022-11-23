class NumUtils < Formula
  desc "Programs for dealing with numbers from the command-line"
  homepage "https://suso.suso.org/xulu/Num-utils"
  url "https://suso.suso.org/programs/num-utils/downloads/num-utils-0.5.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/n/num-utils/num-utils_0.5.orig.tar.gz"
  sha256 "03592760fc7844492163b14ddc9bb4e4d6526e17b468b5317b4a702ea7f6c64e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?num-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8695350e220210f7a33ac87237a246a17bb0a05a7f1ccadf91dbc728421d8cf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8695350e220210f7a33ac87237a246a17bb0a05a7f1ccadf91dbc728421d8cf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1d2623cf894f0d8838ee705b922933605c1fa0a43a6a1dc7e38f7f6ff994c3f"
    sha256 cellar: :any_skip_relocation, ventura:        "8695350e220210f7a33ac87237a246a17bb0a05a7f1ccadf91dbc728421d8cf3"
    sha256 cellar: :any_skip_relocation, monterey:       "8695350e220210f7a33ac87237a246a17bb0a05a7f1ccadf91dbc728421d8cf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1d2623cf894f0d8838ee705b922933605c1fa0a43a6a1dc7e38f7f6ff994c3f"
    sha256 cellar: :any_skip_relocation, catalina:       "b2d299fe6c8307ddfaa2207a4e6ea2767e174d56d9b9cd0366ca00718f81e121"
    sha256 cellar: :any_skip_relocation, mojave:         "b2d299fe6c8307ddfaa2207a4e6ea2767e174d56d9b9cd0366ca00718f81e121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6875dc90327cc2660d36f638c2909d9822f243e80ba837aab7e153de0723b71e"
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

  conflicts_with "normalize", because: "both install `normalize` binaries"
  conflicts_with "crush-tools", because: "both install an `range` binary"
  conflicts_with "argyll-cms", because: "both install `average` binaries"

  def install
    %w[average bound interval normalize numgrep numprocess numsum random range round].each do |p|
      system "#{Formula["pod2man"].opt_bin}/pod2man", p, "#{p}.1"
      bin.install p
      man1.install "#{p}.1"
    end
  end

  test do
    assert_equal "2", pipe_output("#{bin}/average", "1\n2\n3\n").strip
  end
end
