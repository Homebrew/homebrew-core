class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.4.2.tar.gz"
  sha256 "73d3abb058af18329ffdea4bb77d484b5f8ede9c11010d44781f3e891aa675e0"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dbd78fa6843d765085b95e4b695a30a34759cf50873ba102a3cef4c4be2c07f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a24edaa5f6daceefcd0af150472c3c71d3bae049ca289b6b4e72bf19922043c"
    sha256 cellar: :any_skip_relocation, catalina:      "d170385e81d89c53958137852931ec9bdd2b1758ea76e6577120d0f4b3c39ee2"
    sha256 cellar: :any_skip_relocation, mojave:        "2257690325e2c1a8b40dcfa3ba6fb8e5cea6125ff0e9de1e4bdb481fdb7a5a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98869182e3d54e21abe686561612e971dd54e39ffd7c41e4474c2e08dbe9fd4d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
