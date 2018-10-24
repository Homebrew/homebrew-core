class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.18.1.tar.gz"
  sha256 "42277906e03a3bd94234b2deb49f5f8b6d7c38c8adf57ba831f4167f8dd12ebc"
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "4e61b9c3992f927c3f34b562bb62b9cd7bfa9e59cf3062d7e7a99154b5e7e553" => :mojave
    sha256 "f4f08e9dbddfb7882519a860813862e56c747986d0bd4d1bae31c82c68b7dff5" => :high_sierra
    sha256 "4eb70e4ebf9ad20b25a6718cb0ad05219aba25b5c332f68b8269cf48cb13b8f8" => :sierra
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "icu4c"
  depends_on "libzip"
  depends_on :macos => :mavericks

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
