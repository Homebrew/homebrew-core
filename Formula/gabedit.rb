class Gabedit < Formula
  desc "GUI to computational chemistry packages like Gamess-US, Gaussian, etc."
  homepage "https://gabedit.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gabedit/gabedit/Gabedit250/GabeditSrc250.tar.gz"
  version "2.5.0"
  sha256 "45cdde213a09294bbf2df5f324ea11fc4c4045b3f9d58e4d67979e6f071c7689"
  revision 2

  bottle do
    cellar :any
    sha256 "0f506d27f166bbc01901ce42d739c302e4b1b911107900ac37fb002ac0a17a27" => :mojave
    sha256 "dcc74794b5cd1467bf6c7dbea9ca75428bd6ba5fc93b79ba298d440c7b3ab13b" => :high_sierra
    sha256 "628cfbf2a48abddac869ec2a5073677ba80123860a66591cba6102ff268811eb" => :sierra
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
