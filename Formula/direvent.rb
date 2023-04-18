class Direvent < Formula
  desc "Monitors events in the file system directories"
  homepage "https://www.gnu.org.ua/software/direvent/direvent.html"
  url "https://ftp.gnu.org/gnu/direvent/direvent-5.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/direvent/direvent-5.3.tar.gz"
  sha256 "9405a8a77da49fe92bbe4af18bf925ff91f6d3374c10b7d700a031bacb94c497"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56eac8f60269a262b743e7fae5950ab1e4b96adea5337ec46c3c1c2f32f6d6b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1ca94c6ba49376399a6b42ae091c5f8b3f5816dc9ffb6a37354203153f54035"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b70c636ba8ad224c9a5f818e6026a58cc8a5cace37b500dbf4c3e3699f12c78"
    sha256 cellar: :any_skip_relocation, ventura:        "851d631665b043d01df2a154c2a7d1d6bdf8a85fe515f633e25584888f89a3dc"
    sha256 cellar: :any_skip_relocation, monterey:       "2c308ddb297a72378fbbe30a108d101912557b6f5d34216f835823e8a5c6cc05"
    sha256 cellar: :any_skip_relocation, big_sur:        "db43a79498ed9ba81ad83e53242d88e6e1e82fb617888d78b6917f760e37a99e"
    sha256                               x86_64_linux:   "70fc7158afeb6b3e77f13d2d49d299fc6487c600a2695ad0bbd7f1cec69f44da"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/direvent --version")
  end
end
