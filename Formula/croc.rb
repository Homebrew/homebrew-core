class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.2.1.tar.gz"
  sha256 "ecee3dee8506e4c369478f160957a4c2f744675e89a4b7386dd50d1db3f84ccc"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "40c805ceb15f859c85310f3289580d08ec120efc84c439dade34da1e4710de18"
    sha256 cellar: :any_skip_relocation, big_sur:       "b34b7c3bc2053ca96902fe8343c739dc79113949c61dcc7db6edae9be0841fa4"
    sha256 cellar: :any_skip_relocation, catalina:      "d63a12492bb8e591d982b026dd9234b825cf1f7bd4e0cdbf135d6d774ed0ee73"
    sha256 cellar: :any_skip_relocation, mojave:        "c8c7a26785e0e4ab2823bb7516ace348a8d4c88701073544a325bfd60c81b751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "384814e8c1917c6fe3457db235516266880878dc41837c372bca7b371d1be1dd"
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
