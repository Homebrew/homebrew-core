class Coinutils < Formula
  desc "COIN-OR utilities"
  homepage "https://github.com/coin-or/CoinUtils"
  url "https://github.com/coin-or/CoinUtils/archive/refs/tags/releases/2.11.10.tar.gz"
  sha256 "80c7c215262df8d6bd2ba171617c5df844445871e9891ec6372df12ccbe5bcfd"
  license "EPL-2.0"
  head "https://github.com/coin-or/CoinUtils.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{^(?:releases/)?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ec00da73ae5ce6c33a2bbf89c43ddd6df1b9ab10826f2da39f5214fcb991c4f"
    sha256 cellar: :any,                 arm64_ventura:  "e4d6de981b7e8f12e9ae56d94fb5807864618c06d248254b72a57083b9afdfb7"
    sha256 cellar: :any,                 arm64_monterey: "87d125df0b857d8a42a1a1d0237e80a70c7f9984e4043d3f05392ea3daea7bd0"
    sha256 cellar: :any,                 sonoma:         "6c048622f2b24225c77948ae2fb8425852b8acc1cde5c6a23599afaf9e2e1858"
    sha256 cellar: :any,                 ventura:        "f808e437ed6a88ef270454d8d7c2bbe8cc177f80e559bc4cf49990475c06235b"
    sha256 cellar: :any,                 monterey:       "a1db503dabf507b3de876de29084e100221e1eb6a3f626f7a4002efd6c82e4ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "555eb1ef4de9326d93e9023a9922c1546f1621367940e77134eba81442f68e1d"
  end

  depends_on "pkg-config" => :build
  depends_on "openblas"

  resource "homebrew-coin-or-tools-data-sample-p0201-mps" do
    url "https://raw.githubusercontent.com/coin-or-tools/Data-Sample/releases/1.2.11/p0201.mps"
    sha256 "8352d7f121289185f443fdc67080fa9de01e5b9bf11b0bf41087fba4277c07a4"
  end

  def install
    args = [
      "--datadir=#{pkgshare}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--includedir=#{include}/coinutils",
      "--prefix=#{prefix}",
      "--with-blas-incdir=#{Formula["openblas"].opt_include}",
      "--with-blas-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-lapack-incdir=#{Formula["openblas"].opt_include}",
      "--with-lapack-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
    ]
    system "./configure", *args
    system "make"
    # Deparallelize due to error 1: "mkdir: #{include}/coinutils/coin: File exists."
    # https://github.com/coin-or/Clp/issues/109
    ENV.deparallelize { system "make", "install" }
  end

  test do
    resource("homebrew-coin-or-tools-data-sample-p0201-mps").stage testpath
    (testpath/"test.cpp").write <<~EOS
      #include <CoinMpsIO.hpp>
      int main() {
        CoinMpsIO mpsIO;
        return mpsIO.readMps("#{testpath}/p0201.mps");
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{opt_include}/coinutils/coin",
      "-L#{opt_lib}", "-lCoinUtils"
    system "./a.out"
  end
end
