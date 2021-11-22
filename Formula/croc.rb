class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.5.0.tar.gz"
  sha256 "0e250ecebc72753991a3442e48f9caadfae2467430a81595b79b5443e2ff523b"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c87b0d8a63f3b0062fd7bba5dc6e7f3a15d12bc4cb4575d87c195bab3efa9878"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbd78fa6843d765085b95e4b695a30a34759cf50873ba102a3cef4c4be2c07f8"
    sha256 cellar: :any_skip_relocation, monterey:       "0a2034861d5c3ab59fee0723918e803e9801ec65ebf6dac2713c3565cc65a1e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a24edaa5f6daceefcd0af150472c3c71d3bae049ca289b6b4e72bf19922043c"
    sha256 cellar: :any_skip_relocation, catalina:       "d170385e81d89c53958137852931ec9bdd2b1758ea76e6577120d0f4b3c39ee2"
    sha256 cellar: :any_skip_relocation, mojave:         "2257690325e2c1a8b40dcfa3ba6fb8e5cea6125ff0e9de1e4bdb481fdb7a5a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98869182e3d54e21abe686561612e971dd54e39ffd7c41e4474c2e08dbe9fd4d"
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
