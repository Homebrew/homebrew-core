class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "https://github.com/Juniper/libslax/wiki"
  url "https://github.com/Juniper/libslax/releases/download/3.1.2/libslax-3.1.2.tar.gz"
  sha256 "ec1a08620201ac27800fc85f36602b5b9d46f8963647fffe8f9269083b677189"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "1e59fb11b8c40adb7c6fd15f2df4f73fafcdc20ce953f403826ec02dc1f7f285"
    sha256 arm64_sonoma:  "f5be5c35c3cd534e94cd5025f55aa9ce1b32db6fb456fb91cd54c41e2c8bafc5"
    sha256 arm64_ventura: "8cfeabcc8a0ddfd8cfcbed9f4243f27a8aa3da2718b780e61033cb79dc3f04ee"
    sha256 sonoma:        "c2ecc85e4b73c6572d223a7e3e91fcfecd02bd607910ee419f13c1e86bd11d8d"
    sha256 ventura:       "c37c90f83539a4b2751407ac83728e91932317619a6288add31e3dbde0555f68"
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
