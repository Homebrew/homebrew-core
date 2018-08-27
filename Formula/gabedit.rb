class Gabedit < Formula
  desc "GUI to computational chemistry packages like Gamess-US, Gaussian, etc."
  homepage "https://gabedit.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gabedit/gabedit/Gabedit250/GabeditSrc250.tar.gz"
  version "2.5.0"
  sha256 "45cdde213a09294bbf2df5f324ea11fc4c4045b3f9d58e4d67979e6f071c7689"
  revision 1

  bottle do
    cellar :any
    sha256 "d624d25edd3e191cebd3cc12a3ba02c6bc2a48aeee03710e2903215821896913" => :mojave
    sha256 "cd99507c642c1c1791235ac9526c39a1948028ace848c3e13c8fd76bf5b1e305" => :high_sierra
    sha256 "6e52f2894125edc61fef811e907afcbf2033492398ef72f12dacd770b85ee53c" => :sierra
    sha256 "edf727a9900a8e0ef07227bd0ae6a2f5a9d3da1b27841c515b6b3545bba05ed5" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtkglext"

  def install
    opengl_headers = MacOS.sdk_path/"System/Library/Frameworks/OpenGL.framework/Headers"
    (buildpath/"brew_include").install_symlink opengl_headers => "GL"

    inreplace "CONFIG" do |s|
      s.gsub! "-lX11", ""
      s.gsub! "-lpangox-1.0", ""
      s.gsub! "GTKCFLAGS =", "GTKCFLAGS = -I#{buildpath}/brew_include"
    end

    args = []
    args << "OMPLIB=" << "OMPCFLAGS=" if ENV.compiler == :clang
    system "make", *args
    bin.install "gabedit"
  end

  test do
    assert_predicate bin/"gabedit", :exist?
  end
end
