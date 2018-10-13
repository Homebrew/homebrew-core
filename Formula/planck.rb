class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.18.0.tar.gz"
  sha256 "5ed7e297dc0c15efe9c1fe7377863de6cdb27910447a7f3755e8270f081c5151"
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "7866a1f4c900c155486593b7c4494def0239416ecad8fd042932d9afe7148b77" => :mojave
    sha256 "b716e0faf9f5396927d908dc086df0fb5ab8068e5e25f3141744a3c2d6bdc9b0" => :high_sierra
    sha256 "dfc5fbb06a72ea3d5bfd59cc8625d94d9fb89dd617924497aa843607ae1c8116" => :sierra
    sha256 "d8f39c98fe1640eb87dc9c8612856abbe0b6d48aaa6ba85b164b181ad941811d" => :el_capitan
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
