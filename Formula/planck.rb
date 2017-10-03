class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.8.0.tar.gz"
  sha256 "ccafb58d745a67509e3edfce050535177d736fa27241c3202369a6bb34fc97ad"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "ad572492d15c2cbc606a7d0ae9f22be20bd008d56bfb682605b202c46e10c218" => :high_sierra
    sha256 "97ba18bfa544d8eeeb006a7cbb789c9576395581d540834955bf24e685328f48" => :sierra
    sha256 "528041936146c3e78a0ac7c118265ab0ba9a228d177cd8252d1910e6d1dd3f26" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "leiningen" => :build
  depends_on :xcode => :build
  depends_on "libzip"
  depends_on "icu4c"
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
