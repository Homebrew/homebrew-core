class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.6.5.tar.gz"
  sha256 "6fc57c09a112a338a5faad65f48536be673de5cb6f3cb2eeee64ffd663683a8e"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82c31455d6d6010ba7a6012f01adc014075307089f6cd589fbef63b7fe0e435f" => :catalina
    sha256 "8b406f8c1e6be1779a99fbabbb1f539a32703eb7b806e7244ae3ef477c206435" => :mojave
    sha256 "75a7061af51e4db4851e069ac2003cd49103eb28399caa942e1fe085f61a6813" => :high_sierra
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
