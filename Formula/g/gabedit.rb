class Gabedit < Formula
  desc "GUI to computational chemistry packages like Gamess-US, Gaussian, etc."
  homepage "https://gabedit.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gabedit/gabedit/Gabedit251/GabeditSrc251.tar.gz"
  version "2.5.1"
  sha256 "efcb00151af383f662d535a7a36a2b0ed2f14c420861a28807feaa9e938bff9e"
  license "MIT"
  revision 1

  # Consider switching back to checking SourceForge releases once we can alter
  # the matched version from `251` to `2.5.1`.
  livecheck do
    url "https://sites.google.com/site/allouchear/Home/gabedit/download"
    regex(/current stable version of gabedit is v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d50f949dc32c409c6bc33b00840ceb7f85a31490b62155d6ea2a1788395e77bc"
    sha256 cellar: :any,                 arm64_sequoia:  "4218b43130e1be48172b6935ac53abd245973a5a30f46d700b3bb848fed1791a"
    sha256 cellar: :any,                 arm64_sonoma:   "33b7438a8b87b09821c9924d7a5c0a473c95c7abd04189c570b80fc8eeb51bbf"
    sha256 cellar: :any,                 arm64_ventura:  "b2767fead690400c5b24a75122c4f951c02f440b19f8897534ae4af99c48f549"
    sha256 cellar: :any,                 arm64_monterey: "e92333006a163760d34133bbaaa646696c85028baf4e7773cc479a3191e72948"
    sha256 cellar: :any,                 sonoma:         "2b8c19f613ff297dc96f47ccfa68910c4b883e7c4b130e1c49428cde20ec58f9"
    sha256 cellar: :any,                 ventura:        "8acd0846dd0cb1d925b104d87ceb402fe0663fa8bfc1b1ca85d4c3ac719b6c1e"
    sha256 cellar: :any,                 monterey:       "e813fee190a63752c14c08a43dd17616e40d69c56b490dd0c6bb9c933cf1d04f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0b1e20276076f99f0b8662ee3c6a84eacf7bf10d5ce122c42ca0a8063dae9b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85b9f31c8d4f0b7daf320543f5da7d50a20212535bf1c753eca37aaa579c737d"
  end

  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "gtkglext"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

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
      s.gsub! "CC = gcc", "CC = #{ENV.cc}"
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

      # Work around build failures
      # incompatible integer to pointer conversion bug report, https://github.com/allouchear/gabedit/issues/2
      if DevelopmentTools.clang_build_version >= 1403
        s.gsub! " -Wall ",
                " -Wall -Wno-implicit-function-declaration " \
                "-Wno-incompatible-function-pointer-types -Wno-int-conversion "
      end
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
    assert_path_exists bin/"gabedit"
  end
end
