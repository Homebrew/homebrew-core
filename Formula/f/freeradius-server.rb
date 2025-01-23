class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_6.tar.gz"
    sha256 "65e099edf5d72ac2f9f7198c800cf0199544f974aae13c93908ab739815b9625"

    # Fix -flat_namespace being used
    patch do
      url "https://github.com/FreeRADIUS/freeradius-server/commit/6c1cdb0e75ce36f6fadb8ade1a69ba5e16283689.patch?full_index=1"
      sha256 "7e7d055d72736880ca8e1be70b81271dd02f2467156404280a117cb5dc8dccdc"
    end
  end

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "d8273c1e4724a8889b45df7127dc8bc0f9e2311d521d4c37d88d0b60e4268f45"
    sha256 arm64_sonoma:  "550ad29d70fda795a136f5a68a4985a39457608daaed3e8793095bbc239037d3"
    sha256 arm64_ventura: "ea53fcee6f0448a54b68658d3251b7bd47654dbca51b5994464749b50db13ae9"
    sha256 sonoma:        "86e0e4e80f9ca6e4b01fa22c6886a6063acb626305976425508196130e39c8cf"
    sha256 ventura:       "631343eab2dd4aa02175a17c3593a2effcf441e9df705f78562c83eb8565459e"
    sha256 x86_64_linux:  "54af2578552e86f51d43f76f2892e387c71e07297f77083c01178a3ba54ca90e"
  end

  depends_on "collectd"
  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "python@3.13"
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "gdbm"
    depends_on "readline"
  end

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl@3"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@3"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]

    args << "--without-rlm_python" if OS.mac?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    assert_match "77C8009C912CFFCF3832C92FC614B7D1",
                 shell_output("#{bin}/smbencrypt homebrew")

    assert_match "Configuration appears to be OK",
                 shell_output("#{bin}/radiusd -CX")
  end
end
