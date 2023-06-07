class Gabedit < Formula
  desc "GUI to computational chemistry packages like Gamess-US, Gaussian, etc."
  homepage "https://gabedit.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gabedit/gabedit/Gabedit251/GabeditSrc251.tar.gz"
  version "2.5.1"
  sha256 "efcb00151af383f662d535a7a36a2b0ed2f14c420861a28807feaa9e938bff9e"

  # Consider switching back to checking SourceForge releases once we can alter
  # the matched version from `251` to `2.5.1`.
  livecheck do
    url "https://sites.google.com/site/allouchear/Home/gabedit/download"
    regex(/current stable version of gabedit is v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3253d22cef1f9bffab225ca1d371437b83f7c1175d688e1688c527219fc2d822"
    sha256 cellar: :any,                 arm64_monterey: "c2f02dce516ef80da80875e3e1326a9e9c989e8c1f029317e8d0c9375cbd548b"
    sha256 cellar: :any,                 arm64_big_sur:  "5185932b990ba144b26dcae3696d27f8d2b4ecf240c9cac54e53aff6dfe4b127"
    sha256 cellar: :any,                 ventura:        "6515311dbd91d785bf53d931c895deeefe526b3c53bd2d123d85b21a9c86434f"
    sha256 cellar: :any,                 monterey:       "b89b7e33d371e36ed8ec359a56c5fdb86613f2b5239b3c08d3e098bea38f8de2"
    sha256 cellar: :any,                 big_sur:        "5a911e86df1a48febaaf8840303bfeb185e458024fefeb38e09fa22176413fec"
    sha256 cellar: :any,                 catalina:       "da7c3e7a62b1f57f16ffed4423849f03603b3183eea979e2ac5ffd42341ba55d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66a31097edc926ea0029acfb0221368e3d25382cb69cb542123073c65e46aaa0"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtkglext"

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    opengl_headers = if OS.mac?
      MacOS.sdk_path/"System/Library/Frameworks/OpenGL.framework/Headers"
    else
      Formula["mesa"].opt_include
    end

    (buildpath/"brew_include").install_symlink opengl_headers => "GL"

    inreplace "CONFIG" do |s|
      if OS.mac?
        s.gsub! "-lX11", ""
        s.gsub! "-lpangox-1.0", ""
      else
        # Add PKG_CONFIG_PATH to pangox-compat in gtkglext.
        ENV.append_path "PKG_CONFIG_PATH", Formula["gtkglext"].libexec/"lib/pkgconfig"
        s.gsub! "OGLLIB=-L/usr/lib -lGL -L/usr/lib -lGLU",
                "OGLLIB=-L#{Formula["mesa"].opt_lib} -lGL -L#{Formula["mesa-glu"].opt_lib} -lGLU"
      end
      s.gsub! "GTKCFLAGS =", "GTKCFLAGS = -I#{buildpath}/brew_include"
    end

    args = []
    if OS.mac?
      args << "OMPLIB=" << "OMPCFLAGS="
      ENV.append "LDFLAGS", "-undefined dynamic_lookup"
    end
    system "make", *args
    bin.install "gabedit"
  end

  test do
    assert_predicate bin/"gabedit", :exist?
  end
end
