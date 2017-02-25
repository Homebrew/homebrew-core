class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.2.0.tar.gz"
  sha256 "99d37253de53df25260c41db95cc65ee39a4209690c3814a1c5693a3cdf0c9cc"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "34fe06592f3e2ae03167f3b77ef4be5b347bb26b530c1ed21cfd0e6339e66539" => :sierra
    sha256 "5eed6ce3382c07d8681177ae97cc09f250c8064c210bbe267faf7f7121cba816" => :el_capitan
    sha256 "51596af253024076c248618ab80e975150fbff812ce67fc425832ffc2622c57a" => :yosemite
  end

  depends_on "libzip"
  depends_on "icu4c"
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "leiningen" => :build
  depends_on :xcode => :build
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
