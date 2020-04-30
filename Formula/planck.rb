class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.25.0.tar.gz"
  sha256 "58a3f9b0e3d776bc4e28f1e78a8ce6ab1d98149bebeb5c5328cc14345b925a1f"
  revision 2
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "dabaf824617821988990f0bcc0a6936183d979781418a4ebec27dccd2b860337" => :catalina
    sha256 "bce9b5ee6cb8c2a2c48724748c1320eb430875be1dfb69c8a4a2194e9cefc8e1" => :mojave
    sha256 "670344b5e5f0fb52f94cb04d8ed8c2d725eb9c80797411b72c36ae426a3f24d4" => :high_sierra
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
