class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.5.6.tar.gz"
  sha256 "c03c7b9daf2ba841d373d9c43abb68dc27ab1d7e01bbadead771918d499dea9e"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75b525c0b2df83a55f51207e46b77e66e33afa29aa4aa811e8bdaf01fe347b8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5047415856a7db11ce7f30b4ff106c645bccae15c6840da60696aa33afd91582"
    sha256 cellar: :any_skip_relocation, monterey:       "535d7d7a2c68580c50e2c3d71ce0e2d769e8bee4d385e93359ccc8609f77c4fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "74902dfa2e7cc14cfe0b7b86a7757f79c1ad63b66e63cb893b77a5be068a7794"
    sha256 cellar: :any_skip_relocation, catalina:       "0bf7c63c3d193103c7b235824872784223b66fec877dcb1d42b158de1c4330e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5d4ca78fa244be415f3bc40849eb021d7c2a8a79acf352c8ef67c32e0119b6b"
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
