class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "http://graphviz.org/"
  url "http://graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.40.1.tar.gz"
  sha256 "ca5218fade0204d59947126c38439f432853543b0818d9d728c589dfe7f3a421"
  version_scheme 1

  bottle do
    sha256 "5b0261f25e240400997567a643a6c02a56fad9f7c8751a12bb460eacd2063284" => :sierra
    sha256 "e7bf067cb36594de77cdeb2f6701e71d6bc1118127f63cc8a788e932c904b2d2" => :el_capitan
    sha256 "d66468e290a031a97c3b0762ec10163c5164847d31adf3a64bb4bdd640251000" => :yosemite
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
  depends_on "libtool" => :run
  depends_on "pango" => :optional
  depends_on "gts" => :optional
  depends_on "librsvg" => :optional
  depends_on "freetype" => :optional
  depends_on :x11 => :optional
  depends_on "gd"
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
