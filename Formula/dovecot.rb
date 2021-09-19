class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.3/dovecot-2.3.16.tar.gz"
  sha256 "03a71d53055bd9ec528d55e07afaf15c09dec9856cba734904bfd05acbc6cf12"
  license all_of: ["BSD-3-Clause", "LGPL-2.1-or-later", "MIT", "Unicode-DFS-2016", :public_domain]

  livecheck do
    url "https://www.dovecot.org/download/"
    regex(/href=.*?dovecot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "cf575ab457beca6bc27f67d5044d3b46dd3dfaff7693f0b8306b7a57f96dd7af"
    sha256 big_sur:       "c1feffb201e4febf583cae5597f09ffcb595ed050af95b59f3ef342ef394a60e"
    sha256 catalina:      "f3c3f3fce439ab75e20fe6fc49f8e186653afb68c0a9779791a31dd8e04b4850"
    sha256 mojave:        "a8867734064460304e21056d59156f8f01e0b0ec15341e3fac901167eff0bc8f"
    sha256 x86_64_linux:  "c4c1beb8368da32f6743e58c7a0db23397081c366ceddedf026598a4d215241e"
  end

  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "linux-pam"
  end

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-0.5.16.tar.gz"
    sha256 "5ca36780e23b99e6206440f1b3fe3c6598eda5b699b99cebb15d418ba3c6e938"
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
