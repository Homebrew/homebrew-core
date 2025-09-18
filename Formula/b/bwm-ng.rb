class BwmNg < Formula
  desc "Console-based live network and disk I/O bandwidth monitor"
  homepage "https://www.gropp.org/?id=projects&sub=bwm-ng"
  url "https://github.com/vgropp/bwm-ng/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "c1a552b6ff48ea3e4e10110a7c188861abc4750befc67c6caaba8eb3ecf67f46"
  license "GPL-2.0-or-later"
  head "https://github.com/vgropp/bwm-ng.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ec3ddaf321252ebe934527a12aa3e1addb76f797cf5a618f8a9565c3d248d5af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "75b60058b57ac9733b0b3f0b7d83fd14bf2a23c5ef2b05fccc3c0494d773aab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4457d6e94bb59ac3f932011679e08a9b5e5fe594f18c7413cbe41580713949b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08642acf1a9c6cceca48fe1a6ff7cbcf8e3faff906e8ca6b00b8056def0e9f4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6813a187834a07be918ca68fd19356473c06507cc168aa6598c512f66fdf1a27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f572a2c3cba92b810273eec515a00b0dc406319efd33934a571e97a2f48fb9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5dfca0d64c98e4d39184d8dc404148c42a9ffb2b52cde20163237293d72bff98"
    sha256 cellar: :any_skip_relocation, ventura:        "4dff3336a435422ee54cb39a73754d6ac893020c7b583e2cee2cdf8957de6a76"
    sha256 cellar: :any_skip_relocation, monterey:       "5c348d9959e22e50abd4182becbe38b683712988be164097e2ba2c685b49c506"
    sha256 cellar: :any_skip_relocation, big_sur:        "174c1fe863ea893c778909824972bebf6691c399076db4ca638dc2cee3b8c065"
    sha256 cellar: :any_skip_relocation, catalina:       "8ece99c9c9349e80ac741aa8beafc3ea77ae62035279ed5da0c79d201d762882"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3bfce1bb05275a58e441caf13c46aa439cc7bcef34efc5189720fd5490c56e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55c116063a31ada221daff5f86798ab5cb90806e00e02f2b4ffda7092bd5caab"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV.append "CFLAGS", "-std=gnu89"

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "<div class=\"bwm-ng-header\">", shell_output("#{bin}/bwm-ng -o html")
  end
end
