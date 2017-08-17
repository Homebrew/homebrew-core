class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.7.0.tar.gz"
  sha256 "0b1d2431d8f4266e81856a00775d772c0abe14de353dd25da3f3425e9c3366f3"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "d6ff29aa4cd745dad1fa9e61bc7d95f774d73b2c1edcc2a0e047a95b5ea14cf7" => :sierra
    sha256 "4ba4a3c53ef7aa9d80755df3a0d23e2fee7400bcf4c526e5fb4b4f68dae1c4dd" => :el_capitan
    sha256 "e1a4a666c65ea68ab45f5c5981f47f583e16eadfc6e1005e066ffdacbf40e491" => :yosemite
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
