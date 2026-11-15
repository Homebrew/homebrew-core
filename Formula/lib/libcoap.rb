class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/refs/tags/v4.3.5b.tar.gz"
  version "4.3.5b"
  sha256 "383a17d8466cee7c1cb1d4dfbffad2651004850b29eb590e9591c7bedd46741d"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "148d4541164a5107839ff43cd9f237d4fd7027452312e5be39f75d83ff72b8e5"
    sha256 cellar: :any, arm64_tahoe:       "217cd4af1702fdf3e004afc72bd303800c82420002a9c257e32e5a43af33cc0b"
    sha256 cellar: :any, arm64_sequoia:     "0faff1587a9d48cf0d6864c859acd24f7bd2b070957ed5122c7fd248a5adedba"
    sha256 cellar: :any, arm64_linux:       "8e532ce37b03f0c8c4b04e46434d1d541202971f29ba12371ae9b72e12371d9f"
    sha256 cellar: :any, x86_64_linux:      "fd2820c7f5e8ab17f7f22631c1c7a947f5d7f616bf8b6f39bc8218a804e665cf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  # Backport support for OpenSSL 4
  patch do
    url "https://github.com/obgm/libcoap/commit/83ceb9687cfcc3c4683e8b1423ac00ba01c5be3c.patch?full_index=1"
    sha256 "4d22e9267fe8fe8d23424df1ec1fac1ccfffd50d07010d2f459402feb71abcdf"
    type :backport
  end
  patch do
    url "https://github.com/obgm/libcoap/commit/5ea8b7d5e956d1574d78115da007bf23d118f1ae.patch?full_index=1"
    sha256 "58f7d528e62c7a887201f7c47ae91dbe8b09b0f5cdc5a26fb3c685bb4815ea69"
    type :backport
    resolves "https://github.com/obgm/libcoap/pull/2048"
  end

  allow_network_access! :test

  def install
    system "./autogen.sh"
    system "./configure", "--disable-manpages", "--disable-doxygen", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    port = free_port
    spawn bin/"coap-server", "-p", port.to_s
    sleep 1
    output = shell_output("#{bin}/coap-client -B 5 -m get coap://localhost:#{port}")
    assert_match "This is a test server made with libcoap", output
  end
end
