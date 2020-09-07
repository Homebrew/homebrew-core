class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.3.1.tar.gz"
  sha256 "336b6c3ce3930e50326341c9131fd1f2ea207a33b331b0b6d3ce00bc324445f3"
  license "MIT"
  head "https://github.com/schollz/croc.git"

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
