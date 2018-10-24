class Konoha < Formula
  desc "Static scripting language with extensible syntax"
  homepage "https://github.com/konoha-project/konoha3"
  url "https://github.com/konoha-project/konoha3/archive/v0.1.tar.gz"
  sha256 "e7d222808029515fe229b0ce1c4e84d0a35b59fce8603124a8df1aeba06114d3"
  revision 5

  bottle do
    sha256 "09af29e79d082fb23348ad7b8f5e2976794bd33208502d6ec2ca3dfed5380ed4" => :mojave
    sha256 "bbf15f9cac98871a21dae84378117cf2517c90172d41ad27106dc3bb446defec" => :high_sierra
    sha256 "5b4d33a7fdbad806edf3948e53f29e3c7d08695d0538df3ab06cd8ff91bb50b2" => :sierra
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
  depends_on "python"
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
