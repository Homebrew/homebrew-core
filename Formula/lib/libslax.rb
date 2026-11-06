class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "https://github.com/Juniper/libslax/wiki"
  url "https://github.com/Juniper/libslax/releases/download/3.1.6/libslax-3.1.6.tar.gz"
  sha256 "e876068b343c54c40872fdb3c06749dd9cc4826f43fe4bd8247743070d51d9fb"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "1c6a1dd7d503e378b7fec3537bc7b14f545fbf4f4dc89e05aa85bdda891a9325"
    sha256 arm64_tahoe:       "a5613d4bc2c5e4256475bdd86cbd07ca3c7976cecc9da3d33b7355e0ac3b9b08"
    sha256 arm64_sequoia:     "37db7971d0033439284ed4d4b88119e1639548adcbbf27f3caaa84b4c107236a"
  end

  head do
    url "https://github.com/Juniper/libslax.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on :macos # needs libxslt built --with-debugger
  depends_on "openssl@4"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "sqlite"

  conflicts_with "gastown", "genometools", because: "both install `gt` binaries"
  conflicts_with "libxi", because: "both install `libxi.a`"

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", "--enable-libedit", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"hello.slax").write <<~EOS
      version 1.0;

      match / {
          expr "Hello World!";
      }
    EOS

    system bin/"slaxproc", "--slax-to-xslt", "hello.slax", "hello.xslt"
    assert_path_exists testpath/"hello.xslt"
    assert_match "<xsl:text>Hello World!</xsl:text>", File.read("hello.xslt")
  end
end
