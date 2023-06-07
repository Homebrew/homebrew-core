class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.6.4.tar.gz"
  sha256 "e658f15c795da42286563ba5b71e213adfcd8849e5cfba4d3f8451b777c827b9"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14a911c0991b42c7b1a9d7f45253fb1a345ba3fd851a5b077f22325d9b71cefd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14a911c0991b42c7b1a9d7f45253fb1a345ba3fd851a5b077f22325d9b71cefd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14a911c0991b42c7b1a9d7f45253fb1a345ba3fd851a5b077f22325d9b71cefd"
    sha256 cellar: :any_skip_relocation, ventura:        "03fa01cb5b340c28d36024dff9eab51315241a028ac6948b8a1ff6601e6d9191"
    sha256 cellar: :any_skip_relocation, monterey:       "03fa01cb5b340c28d36024dff9eab51315241a028ac6948b8a1ff6601e6d9191"
    sha256 cellar: :any_skip_relocation, big_sur:        "03fa01cb5b340c28d36024dff9eab51315241a028ac6948b8a1ff6601e6d9191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "763481203f40aeb59bb2c01569c76d33d0306edc77005650b85337d17ad21186"
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
