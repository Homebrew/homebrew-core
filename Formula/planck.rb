class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.17.0.tar.gz"
  sha256 "c7907add05bc552fc2c298c27b53978ecd1f656c89bdfbe3c7569b9afc7e6377"
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "b716e0faf9f5396927d908dc086df0fb5ab8068e5e25f3141744a3c2d6bdc9b0" => :high_sierra
    sha256 "dfc5fbb06a72ea3d5bfd59cc8625d94d9fb89dd617924497aa843607ae1c8116" => :sierra
    sha256 "d8f39c98fe1640eb87dc9c8612856abbe0b6d48aaa6ba85b164b181ad941811d" => :el_capitan
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
