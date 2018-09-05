class Konoha < Formula
  desc "Static scripting language with extensible syntax"
  homepage "https://github.com/konoha-project/konoha3"
  url "https://github.com/konoha-project/konoha3/archive/v0.1.tar.gz"
  sha256 "e7d222808029515fe229b0ce1c4e84d0a35b59fce8603124a8df1aeba06114d3"
  revision 4

  bottle do
    sha256 "8252ef153e0736614d4b4387f4b124ea80bc6d4a78e773ad80148ba1f2ca1811" => :mojave
    sha256 "540d50178faec6e28c8107531943c25a11ab5776c2b8929905691f2c370b0c47" => :high_sierra
    sha256 "666717534024275ea2e66e1255e4df3a0f382f43cee5026fbeef2e28a47b8c33" => :sierra
    sha256 "ce642aff879d5e71a26317da1a98fbb7cf41ba1557cf6dafee0e323c2576ca01" => :el_capitan
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
  depends_on "python@2"
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
