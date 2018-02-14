class Konoha < Formula
  desc "Static scripting language with extensible syntax"
  homepage "https://github.com/konoha-project/konoha3"
  url "https://github.com/konoha-project/konoha3/archive/v0.1.tar.gz"
  sha256 "e7d222808029515fe229b0ce1c4e84d0a35b59fce8603124a8df1aeba06114d3"
  revision 3

  bottle do
    sha256 "1f644e81d2932ecc8a816d04decc4ec0640649db58b7bda67cb28d03769dbb05" => :high_sierra
    sha256 "c76e500f004558762edfc2fbd45b4d48c946c19861692bd7c32033b4ad5259a8" => :sierra
    sha256 "fc2b5a70c64bc8cfa74fcfda9b7a9e9f1815c2dcdf8604472306ca7031383456" => :el_capitan
  end

  head do
    url "https://github.com/konoha-project/konoha3.git"

    depends_on "openssl"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "mecab" if MacOS.version >= :mountain_lion
  depends_on "open-mpi"
  depends_on "pcre"
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "sqlite"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test").write "System.p(\"Hello World!\");"
    output = shell_output("#{bin}/konoha #{testpath}/test")
    assert_match "(test:1) Hello World!", output
  end
end
