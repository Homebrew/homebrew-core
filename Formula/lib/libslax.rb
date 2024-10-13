class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "http://www.libslax.org/"
  url "https://github.com/Juniper/libslax/releases/download/0.22.1/libslax-0.22.1.tar.gz"
  sha256 "4da6fb9886e50d75478d5ecc6868c90dae9d30ba7fc6e6d154fc92e6a48d9a95"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Juniper/libslax.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "9a912d3e7a8335a0a88118983dae826c6a6342217fe4dcca0777e60b49c937b0"
    sha256 arm64_sonoma:   "702b5c70a2022383582b60356878b121b09e192f024ce03c88acd6d29c7f7e8f"
    sha256 arm64_ventura:  "fbcd1b639ddfc45b2dde2c0889a959fda82c0aedf88cbb7fcc7496c14cce0cef"
    sha256 arm64_monterey: "0777ecc30f69e7ae8a57c089b1fb6c36819c2781b62514faaa26949ba1ee6adf"
    sha256 arm64_big_sur:  "2e09965e5c95fe93264cce82f9d32a9a046d11fd787829830a41822f0a2d7120"
    sha256 sonoma:         "a0c440e3ff44959eccf1ffe8ffb9bf51bd5620279cc0a28d450bbc7af206091b"
    sha256 ventura:        "345525711533004f5390450cfc300552307bf0aeefbb940f69031099b10d8d12"
    sha256 monterey:       "c323e5e9423cd0201f46342bf7ce05c3e6623367f3f3f9f2db880a6fe59ccea3"
    sha256 big_sur:        "30ab59f88a09b6e5238585a3c00299733c721b6533355629e58a99275916fc25"
    sha256 x86_64_linux:   "433ed00d6104bc49ff4dc3bac740c7854e12e54d5c9f52c4db160f1673398f48"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

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

    system bin/"slaxproc", "--slax-to-xslt", "hello.slax", "hello.xslt"
    assert_predicate testpath/"hello.xslt", :exist?
    assert_match "<xsl:text>Hello World!</xsl:text>", File.read("hello.xslt")
  end
end
