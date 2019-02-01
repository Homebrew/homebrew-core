class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.20.0.tar.gz"
  sha256 "9d982024ac8db3ecc2771c6d0ba0c572143785e8eff9a0a6a7129bb0e41e96c7"
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "0219294cf59d98c2cb6cd8eae40158aea2e387996efd2105fe3b9d3b96c0f933" => :mojave
    sha256 "7724834e36b253d3cdf2e9d9ba2baa8d2e4a2fe13b25ea10aa8200b5135c9d4f" => :high_sierra
    sha256 "8230230d8087f1b0dcfdc96e454378c0dc7329f990997ba8efe4e4831840e467" => :sierra
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "icu4c"
  depends_on "libzip"

  def install
    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
    bin.install "planck-sh/plk"
    man1.install Dir["planck-man/*.1"]
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
