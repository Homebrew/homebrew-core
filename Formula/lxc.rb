class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.1.tar.gz"
  sha256 "319f4e93506e2144edaa280b0185fb37c4374cf7d7468a5e5c8c1b678189250a"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1e096611b0313ec3ffb0f203a83ac2faa137f09f9d2b7dc7b155db8da3996e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fe742240d9d0c2bdf6fe33b8d307e1a3e1a883e9db547b6e908ad0fe4d17049"
    sha256 cellar: :any_skip_relocation, monterey:       "4e1979ca712621d996d0fdb099ec5d3dd7b39c35065101776cd525958e7115e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "74db1f4f046552a6f6c150a537ce76a83d50c196fac64efa5d79ee6b54b8a776"
    sha256 cellar: :any_skip_relocation, catalina:       "77913704357c971487d4172fa7903b834dc5c54c18cc01428099958beda5e192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b0c3f953361db784a9cfb3b15c70460078f2871579b82497292bcc9408f5432"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin

    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
