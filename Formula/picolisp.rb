class Picolisp < Formula
  desc "Minimal Lisp with integrated database"
  homepage "http://picolisp.com/wiki/?home"
  url "https://software-lab.de/picoLisp-17.6.tgz"
  sha256 "0a3883b91ddf501fab35c1a43e20b11755ad27b2e46cbcd83d0c66eb07ef4a5d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8b846b43842406298ecfd6f5153b4e04a199280201513e4878efe48aa1ee563" => :sierra
    sha256 "ffac3fb9ba77a5d339c1898fcab56255cf1e7763742c3ae5749ad10e75819578" => :el_capitan
    sha256 "5760a9797f4477adeadf8bb8cd27d30e406cf5784a911832a759eb09128fedbb" => :yosemite
    sha256 "7b3121d448479a6d6f1d150da4cbe0c6558626edcb7a4cbdb9d6f02230d5bf9b" => :mavericks
  end

  def install
    src_dir = MacOS.prefer_64_bit? ? "src64" : "src"
    system "make", "-C", src_dir
    bin.install "bin/picolisp"
  end

  test do
    path = testpath/"hello.lisp"
    path.write '(prinl "Hello world") (bye)'
    assert_equal "Hello world\n", shell_output("#{bin}/picolisp #{path}")
  end
end
