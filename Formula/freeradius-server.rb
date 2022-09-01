class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_0.tar.gz"
    sha256 "2b8817472847e0b49395facd670be97071133730ffa825bb56386c89c18174f5"

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
    sha256 arm64_monterey: "0dd32ad086a7c9e439f8354f5106f83354baa0e8f677924024e428b4670db67f"
    sha256 arm64_big_sur:  "fc470eb68671ba16cbe38a03679a635403a144bf685bb2a4d87e406b32e1adc9"
    sha256 monterey:       "03bbae657f8de9b1f11bb63a98462c45d5ae2560eb5eb14518efb50b033516a8"
    sha256 big_sur:        "6faccaa51f82dbff25170c1cca15ef212a7527d5daa99e451497301764810a82"
    sha256 catalina:       "adcde92821158f8f2eafe836bc96077995ce9af3bb6fed903b9ddc1b7b0922f5"
    sha256 x86_64_linux:   "374d20ebf25c7e165fb2d3090b689074281b269ad1497a698c44252347095e48"
  end

  depends_on "collectd"
  depends_on "openssl@1.1"
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "readline"
  end

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl@1.1"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@1.1"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    output = shell_output("#{bin}/smbencrypt homebrew")
    assert_match "77C8009C912CFFCF3832C92FC614B7D1", output
  end
end
