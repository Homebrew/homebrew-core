class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "https://www.openssh.com/"

  url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.5p1.tar.gz"
  mirror "https://www.mirrorservice.org/pub/OpenBSD/OpenSSH/portable/openssh-7.5p1.tar.gz"
  version "7.5p1"
  sha256 "9846e3c5fab9f0547400b4d2c017992f914222b3fd1f8eee6c7dc6bc5e59f9f0"

  bottle do
    sha256 "c942ff58039548faeb3f3d4c491e9e620a2fde28393755b231b1a547dfb5c1a1" => :sierra
    sha256 "7ec1b04d0d82c4f32a06455646ef1df505b54266e7351d90bd4270829dc5805c" => :el_capitan
    sha256 "8ba916a853ff38db1273332ddf334f3203e541ff2700908ca5b9804c9ce1c585" => :yosemite
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

  def install
    ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__"

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
    system "make", "install"

    # This was removed by upstream with very little announcement and has
    # potential to break scripts, so recreate it for now.
    # Debian have done the same thing.
    bin.install_symlink bin/"ssh" => "slogin"
  end

  test do
    assert_match "OpenSSH_", shell_output("#{bin}/ssh -V 2>&1")
  end
end
