class Libkate < Formula
  desc "Overlay codec for multiplexed audio/video in Ogg"
  homepage "https://wiki.xiph.org/index.php/OggKate"
  url "https://downloads.xiph.org/releases/kate/libkate-0.4.3.tar.gz"
  sha256 "96827ca136ad496b4e34ff3ed2434a8e76ad83b1e6962b5df06ad24cbbfeebaf"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a920e83dd38ef5cd401c635c08f65dfe0cd6c4b5b79e5edfb4761a76ca729028"
    sha256 cellar: :any,                 arm64_sequoia: "1cc9e076187d3fe58ab436f4729c43fc596c181cf9e5a12125836b676373f0cc"
    sha256 cellar: :any,                 arm64_sonoma:  "45055ede06c87e34cb64389350d61d545a866dfb67b60c5384922f5b479e378f"
    sha256 cellar: :any,                 arm64_ventura: "ac5cad7548115a8aec9fff623487cba4504770caa66a89c61dbcf90b59d79cad"
    sha256 cellar: :any,                 sonoma:        "3ab7c7cda82f7bbfb515d3b9deaadc1dd09069a9a7f47ada41311dd7fc963eff"
    sha256 cellar: :any,                 ventura:       "6cf99c16fdde5990e942310f75915a0465c9dce559ca94c23d3df846f6f17532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af8b104ad8cc5105c019c6c809e4b2897f56458a134f61ede9b1617d043ce547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8e41a5b6906b6cae6d0bd82030cecfd66f1115f39b1669b99baf5501e424452"
  end

  head do
    url "https://gitlab.xiph.org/xiph/kate.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    uses_from_macos "bison" => :build
    uses_from_macos "flex" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libogg"
  depends_on "libpng"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules",
                      "--enable-shared",
                      "--enable-static",
                      *std_configure_args
    system "make", "check"
    system "make", "install"

    rm(man1/"KateDJ.1")
  end

  test do
    system bin/"katedec", "-V"
  end
end
