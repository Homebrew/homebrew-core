class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.5.4.tar.gz"
  sha256 "b89b9d1c2e27e5ca710a7c524f70361122b8b0fd374c0be18f1e7337acca7d07"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd1c5a7e60e900ec42d5a3969f5a5b80a6409a746537c5067f488beeaa6bb9da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f8fe3dbe43c8aa9bc60b3f0b402f9f1894085ce891beb912921af14d0293b3d"
    sha256 cellar: :any_skip_relocation, monterey:       "ae27eb240baab52ca87c7f04d8a1c70cfb0cae947df83af919063230cb120686"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccf3aea10715b34b1d0cfded1551c271c8c6b65719620c36c615d816f32af186"
    sha256 cellar: :any_skip_relocation, catalina:       "546303d2121496a3e1e291ec915c247c177124c9577145b7dfcd954c1c85a030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb59391edcd8bf6a045f4d467e9d7a993b7b361ca25563ed166eb94dc604bf4c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 1

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end
