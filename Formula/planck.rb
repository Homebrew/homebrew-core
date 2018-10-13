class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.18.0.tar.gz"
  sha256 "5ed7e297dc0c15efe9c1fe7377863de6cdb27910447a7f3755e8270f081c5151"
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "866b559f655219afe7f5115571ac6890eebc0a134ceaefdb689e7bbb8b2acbd6" => :mojave
    sha256 "76da0bc09ad6ba97ed07d36cfc82527a7281f8639be30c343b0538b93653aef4" => :high_sierra
    sha256 "3f10415914fbbd2665bdd42b837188488699bbeac4eb83351aa209cc90e3bb4f" => :sierra
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
