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
    rebuild 1
    sha256 arm64_tahoe:   "8923c4cd80df22606925d0a7931e8ba843eb5068f793409ef62953eb510a0d0e"
    sha256 arm64_sequoia: "e449c08d28b2ee074f4957eb8bad98103b151e48985d5c409e829f6ad135ceaa"
    sha256 arm64_sonoma:  "b7904cee97a78679397eba236d9f926b7b5827b5c5b865bd45a8c5e2faffc6f1"
    sha256 sonoma:        "a6f92059c25c4a1e662b27777576fb9610314807e8f29c787e32b11431e76285"
    sha256 arm64_linux:   "0744cf9b0786612ad2e619177e6555c82d863d9fd2f76b7c6655c0d5c77a5c9b"
    sha256 x86_64_linux:  "01e105822a2288b23378fb4c1474d6506a9ecbb74706e64d10368799b28bfdf0"
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
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
