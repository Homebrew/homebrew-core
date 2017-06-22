class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.5.0.tar.gz"
  sha256 "f3a1b9041c38c0d9e4e42aa2791e237562296e942986173d6df0efc6bd226cc7"
  revision 1
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "492c1bc87a56114aaae051b6f2ff2c43119c5a6ad7b27f42e9bc887b9cda9a2d" => :sierra
    sha256 "6ecfcddf2bcea693217c05259258ce83e1c0e384cb6184a1db9651f5237b4ab4" => :el_capitan
    sha256 "ddd3bb7d1cbac50105b556735132cf6dfe60e084325d2e66e6c29e59f69eac78" => :yosemite
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
