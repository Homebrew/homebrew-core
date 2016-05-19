class Planck < Formula
  desc "Stand-alone OS X ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.12.1.tar.gz"
  sha256 "f98763a0b6ed83029ac7eb44af3e57491070b1b8afafa71d485b020fe8f90720"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f67d2c3ee615e80dd012b1ee06630b98f2855576155e119256e46155dd36c03" => :el_capitan
    sha256 "7e962ad87756af06fe3a2fda9d7063c3d6e47dbf247a6b26847a74059edfa3cf" => :yosemite
    sha256 "8587394cd6daca59c4ab3e7a32566384d6c055c4721967c1798f427835d68262" => :mavericks
  end

  depends_on "leiningen" => :build
  depends_on :xcode => :build
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "build/Release/planck"
  end

  test do
    system "#{bin}/planck", "-e", "(- 1 1)"
  end
end
