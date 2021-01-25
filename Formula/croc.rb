class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.6.7.tar.gz"
  sha256 "4124fa4528d2cf3c63cf23e8598f976dfcd702858404cc69f4cd27245ebe0c33"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "588e7145c3caf280ecfe6e7b26984ef5d31712ddb6a4075982ca6fd312859f4a" => :big_sur
    sha256 "b0c1812fd63196e06522818e617794904daee174c71a188818ec41df2ba01e79" => :arm64_big_sur
    sha256 "9d5744a2a3626605a2bf76b3b7fa484e65c9975fbd312d8ab3e925f10b8fb1f1" => :catalina
    sha256 "2cf7cd085941ac02b0426d36637ff163b4858418d37e79b88e59fcf55e5a5380" => :mojave
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
