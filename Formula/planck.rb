class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.25.0.tar.gz"
  sha256 "58a3f9b0e3d776bc4e28f1e78a8ce6ab1d98149bebeb5c5328cc14345b925a1f"
  license "EPL-1.0"
  revision 2
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "5b406713770c2829f37ea2a979339d63e25919d843c2bd99b637965415bc0607" => :catalina
    sha256 "9aa890a053401c91cc47614297141f98c368ffbd10c5bccdcd16dfc44c608926" => :mojave
    sha256 "a5527c52066b07419fef2617323897d21b90b6ce59a5014637eb4c6f234d8596" => :high_sierra
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
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
