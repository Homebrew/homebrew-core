class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.6.12.tar.gz"
  sha256 "8596a70226437178cd87f271d6ad275d6ba391917b1a09c429bc9dc65f446ed4"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1d63eddc9e4d598a7f6633ff045c018f4fcedb20ada2c703ca68b794667fd411"
    sha256 cellar: :any_skip_relocation, big_sur:       "dd8d19c831d11a0641766a00bccbfe21b06f10292cc01a939eb66c338b6adfe2"
    sha256 cellar: :any_skip_relocation, catalina:      "64993fb9073e7601594c7521372c2f291099a15499515094b6d77df46a15d13e"
    sha256 cellar: :any_skip_relocation, mojave:        "a04c8bd6e10e2e5bae8fda53e62880370a443a08b4c5157b36e78dda5369a90c"
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
