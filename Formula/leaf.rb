class Leaf < Formula
  desc "General purpose reloader for all projects"
  homepage "https://pkg.go.dev/github.com/vrongmeal/leaf"
  url "https://github.com/vrongmeal/leaf/archive/v1.3.0.tar.gz"
  sha256 "00ba86c1670e4a547d6f584350d41d174452d0679be25828e7835a8da1fe100a"
  license "MIT"
  head "https://github.com/vrongmeal/leaf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bb7a962b8708d9d607dcff6ed3dba9e485a0963164608662bfcf70e84ad1d5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7880e0f8658071b6040d8e32161e77ef72b6bf7b96489443acfa6b9852af31a"
    sha256 cellar: :any_skip_relocation, monterey:       "6f6e8b0d0775041da2e114e277d6f4790ae4e2b72b1ed409398bc39507b437f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "395fbe11a4e482bf227e460f239ee008f2f6b50e9d071699c703c87d452b8ec0"
    sha256 cellar: :any_skip_relocation, catalina:       "995eb379b3e25e45108bd3c2166baef1fcd6f6ede329572133b8b203261ff9fc"
    sha256 cellar: :any_skip_relocation, mojave:         "c35970131c185aba296c242bc4366eac4636f3c3ab6f791e020bb1024d7c63ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a84a9c0400bd35d736290ce97440f83c844e728b0b79ab95c2b9f88446b2b127"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "go", "build", *std_go_args, "./cmd/leaf/main.go"
  end

  test do
    (testpath/"a").write "foo"
    fork do
      exec bin/"leaf", "-f", "+ a", "-x", "cp a b"
    end
    sleep 1

    assert_equal (testpath/"a").read, (testpath/"b").read
    (testpath/"a").append_lines "bar"
    sleep 1

    assert_equal (testpath/"a").read, (testpath/"b").read
  end
end
