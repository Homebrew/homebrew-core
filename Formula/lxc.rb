class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.7.tar.gz"
  sha256 "4d9785fd53eb3f8a910157b3270416b5fca9b31049a674eb493d2e0ddc375952"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daae7bed20b4e42f971231044a560fee72733630651b88716cdf1e667e577c44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1addd1693ccc5a3a14e0d0998692bbbb629fd8de4007060ee62230e2c8169ef2"
    sha256 cellar: :any_skip_relocation, monterey:       "c84ed2b05cc05e08ab2d53ada838564cd0f091bcf7205edb756b767cab8da0e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fba694138850016211a199ff6eae54523829b551e5ee2b52d08fcf730124730"
    sha256 cellar: :any_skip_relocation, catalina:       "ddf4c9d26ed3ffb81465878051fa6ca2870a3f193c9a1c1278701a4fc668d532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c18dcd39e4c19b312d39f189db98bd5499ab36b75b192a7fc33d8521b352dbb1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]
  end
end
