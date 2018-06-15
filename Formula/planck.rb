class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.15.0.tar.gz"
  sha256 "cab612708d861c488fbe216efc4f89fb026a386b2317867134d61104ac738e0a"
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "9bff998067feabd3b29b3f24e0028834c9a327df3e0e0bf7e1b8a1d1b1f59477" => :high_sierra
    sha256 "ff6582edd244d7db796ee7b6c4698eae44697176c8e1d9ca4d021dd605ac1ce6" => :sierra
    sha256 "c73bf4a0e6b5c218d68b5308d4f8d684aaaf0c770e124d37d3edc1c9888d687e" => :el_capitan
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "libzip"
  depends_on "icu4c"
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
