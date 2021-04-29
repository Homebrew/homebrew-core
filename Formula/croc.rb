class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.1.1.tar.gz"
  sha256 "ca151e59d7a655f2f4cdb06669f568254c2c73f499c2f828055e142702a6a415"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "05e40f72ccfd335aaa232aca6925f1a0b27cb3b14204e0d7090a153643791150"
    sha256 cellar: :any_skip_relocation, big_sur:       "d3fdfdaaf5e51696ddff60e456ba352d9afaded9f4a4ae34c0120b4c0835061e"
    sha256 cellar: :any_skip_relocation, catalina:      "bca67ed851ce2f6b59db857a22f72091bfbe5e67fc62b80fa8413fe95c065b10"
    sha256 cellar: :any_skip_relocation, mojave:        "722fa2cb55c1d31e3073df358e274c1916c4cf5c66575ef64a8a1a655f0fc26a"
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
