class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.16.0.tar.gz"
  sha256 "59e3758f79c4d6b943fc13e759b4e56c9b527d3b04322c58c17e1481cac49e4a"
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "a5098b2d48926f79fb3ceff4f67781ac19185f285c54d2cb1b5dfc8d4c9cd425" => :high_sierra
    sha256 "19b57435fe5cf9a24455a4240d30774f9b519316b1e94ec84c4ad40e6b359ce0" => :sierra
    sha256 "4c15f78fd1f5e307f24c9895b3ef26071f512c47dccb847a27ab8a3a6367e38e" => :el_capitan
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
