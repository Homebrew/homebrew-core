class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "893aedaaf9b701e6847d14e63a0e5609245dae099e3124f3f1095c44595f7b5e"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e787f163b99a3d181c7d80c405d1b28b0e1e3c228008a17fdf1e76f518a787d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e787f163b99a3d181c7d80c405d1b28b0e1e3c228008a17fdf1e76f518a787d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e787f163b99a3d181c7d80c405d1b28b0e1e3c228008a17fdf1e76f518a787d"
    sha256 cellar: :any_skip_relocation, sonoma:        "29fef5f7669f9e1177b8d7dc25d6b960cade021ede591454bd219b0441de54a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91df1223999fa06cae7b2c9c85c44b90dc0166d1dd09991eaf3cc7ae28868217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "551ebd4cffd93ed23342dfb4545112cc3c636579b4b7330f4b94a28071cceaf8"
  end

  depends_on "go" => :build

  conflicts_with "vulsio-gost", because: "both install `gost` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gost"
    prefix.install "README_en.md"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    fork do
      exec bin/"gost", "-L", bind_address
    end
    sleep 2
    output = shell_output("curl -I -x #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match(/Server: GitHub.com/i, output)
  end
end
