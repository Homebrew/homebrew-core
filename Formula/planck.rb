class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.26.0.tar.gz"
  sha256 "e2a01ea5cefcc08399a6bfc7204b228bfd0602b1126d5968fc976f48135a59b2"
  license "EPL-1.0"
  head "https://github.com/planck-repl/planck.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "9ce7bd1d935341e19c8649a608dc484dfad567a0db5de0100fabc8099868008e"
    sha256 cellar: :any, arm64_big_sur:  "15d73a32fea0cd439cc24f637aa9882f47e69e274e9ca24f45c741d5309759fc"
    sha256 cellar: :any, monterey:       "d7d950b46cc246bdac4a782292bcb1c280c7f4f1613778736cee12cd4d052ea2"
    sha256 cellar: :any, big_sur:        "a975776372c01c12ff5a19597a7fb89d37efb60c35032d6625bfe7c7a3b1388e"
    sha256 cellar: :any, catalina:       "35d61599097953290d2f4aa16e317df127e33abc924250f13d22a3a20433cf4a"
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "icu4c"
  depends_on "libzip"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
    bin.install "planck-sh/plk"
    man1.install Dir["planck-man/*.1"]
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
