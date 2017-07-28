class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.6.0.tar.gz"
  sha256 "35de8a63b41c7a940a1f3b2a5d6ca90865c7b7ec21d5b355da3fc1c704f70f41"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "f8b6f93ec5aadcc6a7091cc5bca9b0d728546478b58465171b0b4c132a506bb1" => :sierra
    sha256 "287e93bdefba1a33e952228e2d6525a0431f8bdbc4723c3b55c8a4902341b91e" => :el_capitan
    sha256 "8a472520407b30c16dea4656f39561f90cb1e4711b6fe465e3e54a270accd79e" => :yosemite
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
