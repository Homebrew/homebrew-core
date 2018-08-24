class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "https://www.openssh.com/"
  url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.7p1.tar.gz"
  mirror "https://mirror.vdms.io/pub/OpenBSD/OpenSSH/portable/openssh-7.7p1.tar.gz"
  version "7.7p1"
  sha256 "d73be7e684e99efcd024be15a30bffcbe41b012b2f7b3c9084aed621775e6b8f"
  revision 1

  bottle do
    sha256 "e748ef7bf9feb3b0bb2917cc00fb2a36fb4d4fca131eefb892ccf8926b5fccd8" => :high_sierra
    sha256 "7b0c5e9a9f1c88c3cd0367a3ae69498535886bae6fba385eb40248975614c166" => :sierra
    sha256 "3c74825c289c80afda8a4495b2394780f745a7bc368c13393606dace4edf4bcb" => :el_capitan
  end

  # Please don't resubmit the keychain patch option. It will never be accepted.
  # https://github.com/Homebrew/homebrew-dupes/pull/482#issuecomment-118994372

  depends_on "openssl"
  depends_on "ldns" => :optional
  depends_on "pkg-config" => :build if build.with? "ldns"

  # Both these patches are applied by Apple.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/1860b0a74/openssh/patch-sandbox-darwin.c-apple-sandbox-named-external.diff"
    sha256 "d886b98f99fd27e3157b02b5b57f3fb49f43fd33806195970d4567f12be66e71"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/d8b2d8c2/openssh/patch-sshd.c-apple-sandbox-named-external.diff"
    sha256 "3505c58bf1e584c8af92d916fe5f3f1899a6b15cc64a00ddece1dc0874b2f78f"
  end

  resource "com.openssh.sshd.sb" do
    url "https://opensource.apple.com/source/OpenSSH/OpenSSH-209.50.1/com.openssh.sshd.sb"
    sha256 "a273f86360ea5da3910cfa4c118be931d10904267605cdd4b2055ced3a829774"
  end

  # CVE-2018-15473. Patch safe to remove on next upstream release.
  # http://www.openwall.com/lists/oss-security/2018/08/15/5
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/o/openssh/openssh_7.7p1-4.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/o/openssh/openssh_7.7p1-4.debian.tar.xz"
    sha256 "a7d3a5f9c2b91639f128620c231792698199a2ba0a74fb28dd26204714ccd865"
    apply "patches/upstream-delay-bailout-for-invalid-authenticating-user.patch"
  end

  def install
    ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__"

    # Ensure sandbox profile prefix is correct.
    # We introduce this issue with patching, it's not an upstream bug.
    inreplace "sandbox-darwin.c", "@PREFIX@/share/openssh", etc/"ssh"

    args = %W[
      --with-libedit
      --with-kerberos5
      --prefix=#{prefix}
      --sysconfdir=#{etc}/ssh
      --with-pam
      --with-ssl-dir=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-ldns" if build.with? "ldns"

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

    begin
      pid = fork { exec sbin/"sshd", "-D", "-p", "8022" }
      sleep 2
      assert_match "sshd", shell_output("lsof -i :8022")
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end
