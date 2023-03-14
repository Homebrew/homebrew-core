class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.6.4.tar.gz"
  sha256 "e658f15c795da42286563ba5b71e213adfcd8849e5cfba4d3f8451b777c827b9"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f85655dc1e5f9344cff9d02adbebc2fb280404fdce498f7f09ba7f771b7b14d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce2728a3d09d684a4ad8c4c0f687377180357e7e4864f0d0a6e3298542679f30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0d6c4e5b10d9894fa4a9927b687e3dd8117219690cc033566e10da1eb9461ad"
    sha256 cellar: :any_skip_relocation, ventura:        "30d7310260fdf151abb16a5adb6d303c9f80cb450da6097cc7dd317497b020c6"
    sha256 cellar: :any_skip_relocation, monterey:       "8afc05858ca49f572efe495523a3b968a01a017a63b3e201dcffcb8ac5caf241"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4399e7d4d055fd27269c688e5f556490f94115112b8747b22012b270883718d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc784840b568f80e9ea6956a49eb0200c5f63fae2c7a4f0f1a0c50187995648"
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
