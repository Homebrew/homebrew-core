class Cadaver < Formula
  desc "Command-line client for DAV"
  homepage "https://notroj.github.io/cadaver/"
  url "https://notroj.github.io/cadaver/cadaver-0.28.tar.gz"
  sha256 "33e3a54bd54b1eb325b48316a7cacc24047c533ef88e6ef98b88dfbb60e12734"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?cadaver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "1fb4b0d7f42c9f14ef541bcde82fba19244327b655ebef8e712dee2502be65a0"
    sha256 arm64_tahoe:       "a96c8dcab0526683df4873360e4dd490a8d2ddc88151b3d04587a19ecaa327f2"
    sha256 arm64_sequoia:     "577e6ca9b77deaebe81ad1b413810fae2075084bffd44024c3de58d363e69a98"
    sha256 arm64_linux:       "bebed637097af5ba7b2519b078c06b23848c1b1a257ea0ca5bda0b5171086e38"
    sha256 x86_64_linux:      "c08f5bf10869797619d52d56af8958c1ac21103da291a8790d75ca76375410a1"
  end

  head do
    url "https://github.com/notroj/cadaver.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "neon"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac? # avoid openssl linkage

    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end
    system "./configure", "--with-ssl=openssl",
                          "--with-neon=#{formula_opt_prefix("neon")}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "cadaver #{version}", shell_output("#{bin}/cadaver -V", 255)
  end
end
