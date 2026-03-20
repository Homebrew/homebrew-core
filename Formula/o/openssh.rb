class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "https://www.openssh.com/"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.2p1.tar.gz"
  mirror "https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.2p1.tar.gz"
  version "10.2p1"
  sha256 "ccc42c0419937959263fa1dbd16dafc18c56b984c03562d2937ce56a60f798b2"
  license "SSH-OpenSSH"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/"
    regex(/href=.*?openssh[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "bb44104d05e833f586e97f16452430c72e3e24e9d3dd248f6ec542c89de43371"
    sha256 arm64_sequoia: "4dfd4dd735769919a0040a2e42ef48d863d8d1b4ca89cd4caaf41bbd0ba434d7"
    sha256 arm64_sonoma:  "5d1fa1b293641878d0c7a6bc5db8be0973d3b5ced98dc7fe822cb01018bb8ffc"
    sha256 sonoma:        "f1e4a66b3603f853290efbe81c729078bd5dc7de55a4a696263646db6dc78d1a"
    sha256 arm64_linux:   "3972f75459865fedbd683372c7d8861c116c6cb4a6941a8e875798142d3fcefa"
    sha256 x86_64_linux:  "69c26d0eec36935ad55e2bee0c75bae78d6d66bc0511310b4e9b2dbda52cefd0"
  end

  # Please don't resubmit the keychain patch option. It will never be accepted.
  # https://archive.is/hSB6d#10%25

  depends_on "pkgconf" => :build
  depends_on "ldns"
  depends_on "libfido2"
  depends_on "openssl@3"

  uses_from_macos "mandoc" => :build
  uses_from_macos "lsof" => :test
  uses_from_macos "krb5"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  resource "com.openssh.sshd.sb" do
    url "https://raw.githubusercontent.com/apple-oss-distributions/OpenSSH/OpenSSH-268.100.4/com.openssh.sshd.sb"
    sha256 "a273f86360ea5da3910cfa4c118be931d10904267605cdd4b2055ced3a829774"
  end

  # Fixes regression with PKCS#11 smart cards. Remove in the next release.
  patch do
    url "https://github.com/openssh/openssh-portable/commit/434ba7684054c0637ce8f2486aaacafe65d9b8aa.patch?full_index=1"
    sha256 "18d311b5819538c235aa48b2e4da9b518e4a82cc4570bff6dae116af28396fb1"
  end

  # Fixes regression with PKCS#11 smart cards. Remove in the next release.
  patch do
    url "https://github.com/openssh/openssh-portable/commit/607f337637f2077b34a9f6f96fc24237255fe175.patch?full_index=1"
    sha256 "b13d736aaabe2e427150ae20afb89008c4eb9e04482ab6725651013362fbc7fe"
  end

  def install
    ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__" if OS.mac?

    args = %W[
      --sysconfdir=#{etc}/ssh
      --with-ldns
      --with-libedit
      --with-kerberos5
      --with-pam
      --with-ssl-dir=#{Formula["openssl@3"].opt_prefix}
      --with-security-key-builtin
    ]

    args << "--with-privsep-path=#{var}/lib/sshd" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"

    # This was removed by upstream with very little announcement and has
    # potential to break scripts, so recreate it for now.
    # Debian have done the same thing.
    bin.install_symlink bin/"ssh" => "slogin"

    buildpath.install resource("com.openssh.sshd.sb")
    (etc/"ssh").install "com.openssh.sshd.sb" => "org.openssh.sshd.sb"

    # Don't hardcode Cellar paths in configuration files
    inreplace etc/"ssh/sshd_config", prefix, opt_prefix
  end

  test do
    (etc/"ssh").find do |pn|
      next unless pn.file?

      refute_match HOMEBREW_CELLAR.to_s, pn.read
    end

    assert_match "OpenSSH_", shell_output("#{bin}/ssh -V 2>&1")

    port = free_port
    spawn sbin/"sshd", "-D", "-p", port.to_s
    sleep 2
    assert_match "sshd", shell_output("lsof -i :#{port}")
  end
end
