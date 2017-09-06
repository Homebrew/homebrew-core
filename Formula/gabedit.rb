class Gabedit < Formula
  desc "GUI to computational chemistry packages like Gamess-US, Gaussian, etc."
  homepage "https://gabedit.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gabedit/gabedit/Gabedit250/GabeditSrc250.tar.gz"
  version "2.5.0"
  sha256 "45cdde213a09294bbf2df5f324ea11fc4c4045b3f9d58e4d67979e6f071c7689"

  bottle do
    cellar :any
    sha256 "65355757dc6da502a9c0e1716aa0a7048f50b6b67fcd2325988ae0b629ba3bd0" => :sierra
    sha256 "d32b12a340be7d2c2ae089ed2a6488063cd12b419e68cf6eb16d18761acb34be" => :el_capitan
    sha256 "a48b0977eacecc156b170dbd1b8730d5f694e09aa9553b88e0dc6b68aa3e6cbb" => :yosemite
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
    assert (bin/"gabedit").exist?
  end
end
