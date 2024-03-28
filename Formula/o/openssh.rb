class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "https://www.openssh.com/"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.7p1.tar.gz"
  mirror "https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.7p1.tar.gz"
  version "9.7p1"
  sha256 "490426f766d82a2763fcacd8d83ea3d70798750c7bd2aff2e57dc5660f773ffd"
  license "SSH-OpenSSH"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/"
    regex(/href=.*?openssh[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "447bfbf4b1c31720c1bad753cf207f234b52cb1fea5b0a474708a6251e82dff2"
    sha256 arm64_ventura:  "74ad631d8504351d31259ac7aae694a81097b04739f9a2f1e6a28e42ca60834b"
    sha256 arm64_monterey: "ba7b58021803bdecef4c8ac9ed33e6f8c3788c47ee00548bbab4bb0a937c8ef9"
    sha256 sonoma:         "87eedfb466961ad64757901871958b25eb15090aa3b261142bdf21250c6905d8"
    sha256 ventura:        "379cdb985a280265a8451180838044c8fca07e02c2972ab9da846a602288082c"
    sha256 monterey:       "119e9396d914c59f94eabab53fb66bdc5f0d180da000c77ee3deddb269fae94c"
    sha256 x86_64_linux:   "df5724bab105958f71a2ff1d880785d14940bceb7e8da6a6655b55bc64c05ebb"
  end

  # Please don't resubmit the keychain patch option. It will never be accepted.
  # https://archive.is/hSB6d#10%25

  depends_on "pkg-config" => :build
  depends_on "ldns"
  depends_on "libfido2"
  depends_on "openssl@3"

  uses_from_macos "mandoc" => :build
  uses_from_macos "lsof" => :test
  uses_from_macos "krb5"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_macos do
    # Both these patches are applied by Apple.
    # https://github.com/apple-oss-distributions/OpenSSH/blob/main/openssh/sandbox-darwin.c#L66
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/1860b0a745f1fe726900974845d1b0dd3c3398d6/openssh/patch-sandbox-darwin.c-apple-sandbox-named-external.diff"
      sha256 "d886b98f99fd27e3157b02b5b57f3fb49f43fd33806195970d4567f12be66e71"
    end

    # https://github.com/apple-oss-distributions/OpenSSH/blob/main/openssh/sshd.c#L532
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/d8b2d8c2612fd251ac6de17bf0cc5174c3aab94c/openssh/patch-sshd.c-apple-sandbox-named-external.diff"
      sha256 "3505c58bf1e584c8af92d916fe5f3f1899a6b15cc64a00ddece1dc0874b2f78f"
    end
  end

  on_linux do
    depends_on "linux-pam"
  end

  resource "com.openssh.sshd.sb" do
    url "https://raw.githubusercontent.com/apple-oss-distributions/OpenSSH/OpenSSH-268.100.4/com.openssh.sshd.sb"
    sha256 "a273f86360ea5da3910cfa4c118be931d10904267605cdd4b2055ced3a829774"
  end

  def install
    if OS.mac?
      ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__"

      # Ensure sandbox profile prefix is correct.
      # We introduce this issue with patching, it's not an upstream bug.
      inreplace "sandbox-darwin.c", "@PREFIX@/share/openssh", etc/"ssh"

      # FIXME: `ssh-keygen` errors out when this is built with optimisation.
      # Reported upstream at https://bugzilla.mindrot.org/show_bug.cgi?id=3584
      # Also can segfault at runtime: https://github.com/Homebrew/homebrew-core/issues/135200
      if Hardware::CPU.intel? && DevelopmentTools.clang_build_version == 1403
        inreplace "configure", "-fzero-call-used-regs=all", "-fzero-call-used-regs=used"
      end
    end

    args = *std_configure_args + %W[
      --sysconfdir=#{etc}/ssh
      --with-ldns
      --with-libedit
      --with-kerberos5
      --with-pam
      --with-ssl-dir=#{Formula["openssl@3"].opt_prefix}
      --with-security-key-builtin
    ]

    args << "--with-privsep-path=#{var}/lib/sshd" if OS.linux?

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"

    # This was removed by upstream with very little announcement and has
    # potential to break scripts, so recreate it for now.
    # Debian have done the same thing.
    bin.install_symlink bin/"ssh" => "slogin"

    buildpath.install resource("com.openssh.sshd.sb")
    (etc/"ssh").install "com.openssh.sshd.sb" => "org.openssh.sshd.sb"
  end

  test do
    assert_match "OpenSSH_", shell_output("#{bin}/ssh -V 2>&1")

    port = free_port
    fork { exec sbin/"sshd", "-D", "-p", port.to_s }
    sleep 2
    assert_match "sshd", shell_output("lsof -i :#{port}")
  end
end
