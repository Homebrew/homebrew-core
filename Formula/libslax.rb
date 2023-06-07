class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "http://www.libslax.org/"
  url "https://github.com/Juniper/libslax/releases/download/0.22.1/libslax-0.22.1.tar.gz"
  sha256 "4da6fb9886e50d75478d5ecc6868c90dae9d30ba7fc6e6d154fc92e6a48d9a95"
  license "BSD-3-Clause"
  head "https://github.com/Juniper/libslax.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "25abcd8291903ee58e0ec2b1d8ef1d8fca64c8dfb0468727cf5b4c2dd3dc99d9"
    sha256 arm64_monterey: "2353ab7cd0966b2b227bb148a56296d596ce17891d602f5d5171d658aa725813"
    sha256 arm64_big_sur:  "c75218d25fb9630e5925ac7d83cf2a087fbad12d5cac213bc6c31193245b8e24"
    sha256 ventura:        "547c315cdbbd82fa4fcd970e3e2ee43561aad77c948e186054f67a2a3300a6ce"
    sha256 monterey:       "8a675ef7730a28f0179f368890940f407ee80f33f40af68634ebe0f20bb624a4"
    sha256 big_sur:        "e155b74af4563cfc2236a8c473154275118b978bf068329e941f3f6ecf58fea5"
    sha256 catalina:       "8b4506f10c72d75425ad849f17918a6574c349ebdf29ab740ad323811d1a4d02"
    sha256 mojave:         "5e024a22f8a47c0a11724d7543cd50141e8246b3669155cd734854ee74ec9d71"
    sha256 high_sierra:    "95e8b6bdc7010103110d8c7a92c33dd8e2e04228e037ca81c3a5cb69ea955ab2"
    sha256 x86_64_linux:   "d6408934888b53ea175db0ee882e2ad40df936739df4d3fddabbcf1d1795ad68"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "sqlite"

  conflicts_with "genometools", because: "both install `bin/gt`"
  conflicts_with "libxi", because: "both install `libxi.a`"

  # Fix compilation when using bison 3.7.6+. Patch accepted upstream, remove on next release
  patch do
    url "https://github.com/Juniper/libslax/commit/cc693df657bc078cd11abe910cbb94ce2acaed67.patch?full_index=1"
    sha256 "68cdafb11450cd07bdfd15e5309979040e5956c3e36d9f8978890c29c8f20e87"
  end

  # Fix detection of libxml2 in configure. Two following patches accepted upstream, remove on next release
  patch do
    url "https://github.com/Juniper/libslax/commit/5fda392d357b753f7e163f94b8795c028300b024.patch?full_index=1"
    sha256 "0a424f900e76faa8f1f1c7de282455d1b77c402329a6dc0be7e6370e9aa790de"
  end

  patch do
    url "https://github.com/Juniper/libslax/commit/c1b0ba1a342bd4f1ee58f8a339cbd29938d58ba9.patch?full_index=1"
    sha256 "fa5ecd56672843838cef62d7d44520613c5fa0e5904e3497266d0ee45b16df04"
  end

  def install
    # Upstream patches have already bumped package version in configure.ac ahead of new release being tagged,
    # remove on next release
    inreplace "configure.ac",
              "AC_INIT([libslax],[0.22.2],[phil@juniper.net])",
              "AC_INIT([libslax],[#{version}],[phil@juniper.net])"

    system "autoreconf", "--force", "--install", "--verbose"

    args = std_configure_args + %w[--enable-libedit]
    args << "--with-sqlite3=#{Formula["sqlite"].opt_prefix}" if OS.linux?

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"hello.slax").write <<~EOS
      version 1.0;

      match / {
          expr "Hello World!";
      }
    EOS
    system "#{bin}/slaxproc", "--slax-to-xslt", "hello.slax", "hello.xslt"
    assert_predicate testpath/"hello.xslt", :exist?
    assert_match "<xsl:text>Hello World!</xsl:text>", File.read("hello.xslt")
  end
end
