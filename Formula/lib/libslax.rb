class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "https://github.com/Juniper/libslax/wiki"
  url "https://github.com/Juniper/libslax/releases/download/3.1.3/libslax-3.1.3.tar.gz"
  sha256 "d3ea2e117d4f2a79c8145ceb43a5ca47f5018a81f69c4e80f44685b2be88f11b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "f7c73752314c9acf4682fc3d09e944f939a9c8c5d51ef4252b4adaf286bd86c4"
    sha256 arm64_sonoma:  "8652761bd9c2d3413b5c9fd201441025564a14dff40afbac7d352e5edfdda77b"
    sha256 arm64_ventura: "c0022358c0853960e69f645c77637bf5c0ac103ce6e485bb170d31e1fbe670e7"
    sha256 sonoma:        "807d9168bcf21c17abe2825d89badc7cbf8342be5288afccc1debd17cf7acf3b"
    sha256 ventura:       "5ddf09d52eac4fedd017eb6bc6ab7eda3517d5ad5feedc413ae5b63c3a16ddb3"
  end

  head do
    url "https://github.com/Juniper/libslax.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on :macos # needs libxslt built --with-debugger
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "sqlite"

  conflicts_with "genometools", because: "both install `bin/gt`"
  conflicts_with "libxi", because: "both install `libxi.a`"

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
