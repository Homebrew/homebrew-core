class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.6.7.tar.gz"
  sha256 "4124fa4528d2cf3c63cf23e8598f976dfcd702858404cc69f4cd27245ebe0c33"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23579d60130ae5ba026dc58fc909483051c9994c4a38780058dde8a282d0b466" => :big_sur
    sha256 "b95ca6096e3556c4876d02451b674658e47aa11414395fb40eb2f918df53f742" => :arm64_big_sur
    sha256 "3bc651c2c8e2f807a68d48b2d25fe6bbcb8725595f08ba11eede1f30008a70f3" => :catalina
    sha256 "d0de80f9f4221c1de3240a03d7851bbfee5bb4c0842d4bb76f0689d14b682359" => :mojave
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
