class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.17.0.tar.gz"
  sha256 "c7907add05bc552fc2c298c27b53978ecd1f656c89bdfbe3c7569b9afc7e6377"
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "865b1191d6ffa72d507a9b6101773ce51dd98a619e0376beee7de5ab5eb0b256" => :high_sierra
    sha256 "2ba5a7821d95e4ac47cb9bc1a534eaa7e3c685a3a6e74e0dd973e6cb2e9d3723" => :sierra
    sha256 "d932424940110287f16b8760f06bb22b1480bdd26c1bb5e5589d2e273709b7bb" => :el_capitan
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
