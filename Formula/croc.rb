class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.3.0.tar.gz"
  sha256 "a55153b4b13aae2986e4fe3e5f652228a83835bf27651e83a71750f4942c612d"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8256fb33e8e47a4fbe901afc8b9282af3aa1620f810ce29b2687f233917f2608"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b9a0ddfe4d398d8d629c497c691538588fc6fe6a7c239fa94eacefaec632783"
    sha256 cellar: :any_skip_relocation, catalina:      "89cff0a393779ba14649be8ca763dd7a497dabbf4d8f1069e497cb983bafe848"
    sha256 cellar: :any_skip_relocation, mojave:        "0c42bb8e396fe08541fa01a0e7b941cb33ca97f6b2b680dec72b64c9f4629406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc2f85c30ddad40b6b1d539136bc284e1228d4b04aa630cd95f52601ae54192"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"croc", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 5

    assert_match "mytext", pipe_output(bin/"croc --yes homebrew-test", "y\n") if OS.mac?
    assert_match shell_output("#{bin}/croc --yes homebrew-test").chomp, "mytext" if OS.linux?
  end
end
