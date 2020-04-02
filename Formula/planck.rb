class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.25.0.tar.gz"
  sha256 "58a3f9b0e3d776bc4e28f1e78a8ce6ab1d98149bebeb5c5328cc14345b925a1f"
  revision 1
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "63e3d9501671560c3e5c00020f0c9b4f2c1d8b8a23982684a1c8c7cba2118b92" => :catalina
    sha256 "293709653ba184a8aacfbe28ad6dd59d5343f126bc9ff20661ae310e689ec350" => :mojave
    sha256 "1b1b15662a1a5f49c5b721d560778bb79831b7cbe9d249fae20dbc0cd8aa152c" => :high_sierra
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
