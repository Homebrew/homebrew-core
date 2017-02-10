class Chezscheme < Formula
  desc "Chez Scheme"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.4.tar.gz"
  sha256 "9f4e6fe737300878c3c9ca6ed09ed97fc2edbf40e4cf37bd61f48a27f5adf952"

  bottle do
    sha256 "b781813aa808743355d6f5287ea614d648c2394023f61179c2747fe9e367347b" => :sierra
    sha256 "0ba364536190033f5758ef73f673f42054b636c843430ee7a7cdccba312fbc79" => :yosemite
  end

  depends_on :x11 => :build

  def install
    system "./configure",
              "--installprefix=#{prefix}",
              "--threads",
              "--installschemename=chez"
    system "make", "install"
  end

  test do
    (testpath/"hello.ss").write <<-EOS.undent
      (display "Hello, World!") (newline)
    EOS

    expected = <<-EOS.undent
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/chez --script hello.ss")
  end
end
