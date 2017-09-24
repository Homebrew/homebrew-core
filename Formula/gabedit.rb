class Gabedit < Formula
  desc "GUI to computational chemistry packages like Gamess-US, Gaussian, etc."
  homepage "https://gabedit.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gabedit/gabedit/Gabedit250/GabeditSrc250.tar.gz"
  version "2.5.0"
  sha256 "45cdde213a09294bbf2df5f324ea11fc4c4045b3f9d58e4d67979e6f071c7689"

  bottle do
    cellar :any
    sha256 "5c4b24ec80ff5e567a7b50e4a2c62aad0d70009179534363bc8be60c66cc3484" => :high_sierra
    sha256 "22d5d4524dae2675c9184b322c6554331112fd799d1a8466b9e9d6338ada7ca5" => :sierra
    sha256 "2e8e35a860589f035a40ddde03bfabc6908308ec5fac3fcefeb1e0a8a5a0f053" => :el_capitan
    sha256 "3dcde0ef2c31cc12898b477370d571d2091d8f2a1c858e8deb71a4fa8b52bf09" => :yosemite
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
