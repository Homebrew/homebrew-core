class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.1.6.tar.gz"
  sha256 "0a4119717346ec580f074e4ca70dedb8af99967f41e5592e93d1650bdd0aabf7"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e22803641c241e653acf2747e657e295a03b2fea8823754f87f363c1117bb5b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f2f5d193b63a4990bddf0020a3a6a345520da23edac1a1d200b4eab52ed7095"
    sha256 cellar: :any_skip_relocation, catalina:      "fde40b297161c2cb10edd19f46b8d8aa25590908b7b2c78f00a9864777b5036f"
    sha256 cellar: :any_skip_relocation, mojave:        "b4dc28f655dfc41e00f9895246346c37c42a7c7b2c62c8daf1a54ac8ff41e9d8"
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
