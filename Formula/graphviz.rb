class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "http://graphviz.org/"
  url "http://graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.40.20161221.0239.tar.gz"
  sha256 "49141bc9a9ac0d31e091551bc1319ea3dd0c0c9ead94aed50c76805cc90b983a"

  bottle do
    sha256 "8cdecc90167e47c11153a8cde909f4387b96abee37a6e59cd7024112ba4709cc" => :sierra
    sha256 "c36aa173c45aecedee2aa2c6b410e8b609a4fcab1a81c948a705388e7265a7b3" => :el_capitan
    sha256 "655323ee62b7328acb15e46f2d099103f6a774895b909b9a51011f5254688cfb" => :yosemite
  end

  head do
    url "https://github.com/ellson/graphviz.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-bindings", "Build Perl/Python/Ruby/etc. bindings"
  option "with-pango", "Build with Pango/Cairo for alternate PDF output"
  option "with-app", "Build GraphViz.app (requires full XCode install)"
  option "with-gts", "Build with GNU GTS support (required by prism)"

  deprecated_option "with-x" => "with-x11"
  deprecated_option "with-pangocairo" => "with-pango"

  depends_on "pkg-config" => :build
  depends_on :xcode => :build if build.with? "app"
  depends_on "pango" => :optional
  depends_on "gts" => :optional
  depends_on "librsvg" => :optional
  depends_on "freetype" => :optional
  depends_on :x11 => :optional
  depends_on "libpng"

  if build.with? "bindings"
    depends_on "swig" => :build
    depends_on :python
    depends_on :java
    depends_on "ruby"
  end

  def install
    # Only needed when using superenv, which causes qfrexp and qldexp to be
    # falsely detected as available. The problem is triggered by
    #   args << "-#{ENV["HOMEBREW_OPTIMIZATION_LEVEL"]}"
    # during argument refurbishment of cflags.
    # https://github.com/Homebrew/brew/blob/ab060c9/Library/Homebrew/shims/super/cc#L241
    # https://github.com/Homebrew/legacy-homebrew/issues/14566
    # Alternative fixes include using stdenv or using "xcrun make"
    inreplace "lib/sfio/features/sfio", "lib qfrexp\nlib qldexp\n", ""

    if build.with? "bindings"
      # the ruby pkg-config file is version specific
      inreplace "configure", "ruby-1.9",
                             "ruby-#{Formula["ruby"].stable.version.to_f}"
    end

    ENV.universal_binary if build.universal?
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-qt
      --with-quartz
    ]
    args << "--with-gts" if build.with? "gts"
    args << "--disable-swig" if build.without? "bindings"
    args << "--without-pangocairo" if build.without? "pango"
    args << "--without-freetype2" if build.without? "freetype"
    args << "--without-x" if build.without? "x11"
    args << "--without-rsvg" if build.without? "librsvg"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"

    if build.with? "app"
      cd "macosx" do
        xcodebuild "SDKROOT=#{MacOS.sdk_path}", "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}",
                   "ONLY_ACTIVE_ARCH=YES", "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
      end
      prefix.install "macosx/build/Release/Graphviz.app"
    end

    (bin/"gvmap.sh").unlink
  end

  test do
    (testpath/"sample.dot").write <<-EOS.undent
    digraph G {
      a -> b
    }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
