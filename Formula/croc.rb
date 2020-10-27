class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.6.5.tar.gz"
  sha256 "6fc57c09a112a338a5faad65f48536be673de5cb6f3cb2eeee64ffd663683a8e"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "98249aa16eaf16722abd3a0cc6c98c4499d26b644909ee8879e01a3fac878ffa" => :catalina
    sha256 "71fec2667e693fbdc000d8ac4bc99f1b1898101d963c84247f23add13c1af13e" => :mojave
    sha256 "c294ca113397098cf77867dfbd042fc69ebc7fa52c418b08cb04049a730b00fb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"croc", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --yes homebrew-test").chomp, "mytext"
  end
end
