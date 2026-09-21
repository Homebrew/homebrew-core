class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.23.tar.gz"
  sha256 "702d6cb6f4bfdcaae4aeacf83ec514b05f18e9519883a8e9f9807566d7dae799"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b2f85d4aad015c7fa5d851c0c33c5ea42db173547564376a57363f5dbca27472"
    sha256 cellar: :any, arm64_tahoe:       "fb1e0b76d4a44dbc7e38b265b78d64796a0281f9c607bdd66ed5fa4f0bb6cd82"
    sha256 cellar: :any, arm64_sequoia:     "ec8c3792b546404f8f8c3cccf3be13df5af25c40a38054ac0515f9a87f6825b3"
    sha256 cellar: :any, arm64_linux:       "b370360dc5e9eaf4381c0e97cc86fac8a8f51730bc1fac1440f4c684311e7f63"
    sha256 cellar: :any, x86_64_linux:      "f70145f7a8fb5c5cd8ffce08ecdc7e8fe350237cae1c02d1740418d3356d85f6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "libtorrent-rasterbar", because: "both use the same libname"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>#{"  "}
      #include <torrent/runtime/runtime.h>
      int main(void)
      {
        std::cout << torrent::runtime::version() << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    assert_match version.to_s, shell_output("./test").strip
  end
end
