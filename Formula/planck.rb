class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.22.0.tar.gz"
  sha256 "2782022dd3a58ea1004c8ddccf1a98839e73e1778f7a163b224d2eb0d83f0752"
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "a12379d17d32d47ebaaf62164e55157c193493bcde25352331d0cd663fb02e89" => :mojave
    sha256 "14ba7a790bb7f9c635529c0079d7867327a3622992766633324e8225a3566df9" => :high_sierra
    sha256 "787c6c717bbedf3240dcba483962df682228cff5a601e827508a7bed592a535b" => :sierra
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
