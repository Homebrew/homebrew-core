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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffb82a0c32f13692ea62d5f324cbd24776c5e952e064d9600ad1ad1541c60a0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f427a0423bcade523fa52c4e442d274eff4c617c106be23689f1d981fe64ed0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e0562fa3e4c38677d48d50b13f0e5c28ec449c06c8e414de1abcae0db707f8a"
    sha256 cellar: :any_skip_relocation, ventura:        "05ffa03a293a80d9036605d6e8853c6ba87d3b42a8dddda9acc5e2e59bcc0dc9"
    sha256 cellar: :any_skip_relocation, monterey:       "3ca4a12d0c7746f6dbe236e9380559bd1d673c6cd28fbea6c976f7a0c437fba0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e1e3ea84812941c51f446a7b3d26c6cd35443662f8220c37da75114fc2b23e3"
    sha256 cellar: :any_skip_relocation, catalina:       "ce682ccbb1300b0a0070829f2c8bcb2f1b3f6fa9489f40f7d31f999cac66f864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b29e772bf32c5f57d416c575f9fa50b6d3d50f49eb3c745509e34b0dd51c56fa"
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
