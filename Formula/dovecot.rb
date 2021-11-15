class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.3/dovecot-2.3.17.tar.gz"
  sha256 "224412cd77a23a3ffb857da294da200883d956082cff7257942eff2789bd2df9"
  license all_of: ["BSD-3-Clause", "LGPL-2.1-or-later", "MIT", "Unicode-DFS-2016", :public_domain]

  livecheck do
    url "https://www.dovecot.org/download/"
    regex(/href=.*?dovecot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6a09e1d80034aacab3b64db30ab1f22e69b19b1bf3f02c4dbe575d60c516071f"
    sha256 arm64_big_sur:  "97ee2d2b1c2214d6fd00211e4deb99a2476eff51a135bc9e97367fed98c2cbae"
    sha256 monterey:       "9c1c6a718ddc61b95705ce76f4504066a877a5385c2b10fbd97e0ace8b21118f"
    sha256 big_sur:        "0e2332671e5df12e9dc1cc947d413b0b4555d7bdb80ceaea944e7623cba1767f"
    sha256 catalina:       "c047e4e19250f80ae8ed466a6e097ba22e727efa01f349335d51f4925bc731cf"
    sha256 x86_64_linux:   "4bf69f94e1276372205ea581baa2b2e15baa98ca6b852307c938d5e609edb61c"
  end

  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "linux-pam"
  end

  resource "pigeonhole" do
    # Syystem curl errors with:
    # curl: (35) error:1400442E:SSL routines:CONNECT_CR_SRVR_HELLO:tlsv1 alert protocol version
    url "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-0.5.17.tar.gz", using: :homebrew_curl
    sha256 "031e823966c53121e289b3ecdcfa4bc35ed9d22ecbf5d93a8eb140384e78d648"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-bzlib
      --with-pam
      --with-sqlite
      --with-ssl=openssl
      --with-zlib
    ]

    system "./configure", *args
    system "make", "install"

    resource("pigeonhole").stage do
      args = %W[
        --disable-dependency-tracking
        --with-dovecot=#{lib}/dovecot
        --prefix=#{prefix}
      ]

      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      For Dovecot to work, you may need to create a dovecot user
      and group depending on your configuration file options.
    EOS
  end

  plist_options startup: true

  service do
    run [opt_sbin/"dovecot", "-F"]
    environment_variables PATH: std_service_path_env
    error_log_path var/"log/dovecot/dovecot.log"
    log_path var/"log/dovecot/dovecot.log"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dovecot --version")
  end
end
