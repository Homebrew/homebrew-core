class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "https://www.openssh.com/"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.0p2.tar.gz"
  mirror "https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.0p2.tar.gz"
  version "10.0p2"
  sha256 "021a2e709a0edf4250b1256bd5a9e500411a90dddabea830ed59cef90eb9d85c"
  license "SSH-OpenSSH"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/"
    regex(/href=.*?openssh[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "7c10ac8dc8b6a14cfd638436c3c7f74017bec24a0a2e240d06e31b452195865a"
    sha256 arm64_sequoia: "7389e350d66dd63bfde69bf423bdc64ffc640e2cca096c05dc68aa98a546ef2a"
    sha256 arm64_sonoma:  "efda31ef626a2499082eb8fdcff8915377b29be10284cd502bd74753dc42621d"
    sha256 arm64_ventura: "83893341782c137e23dcdd013f87f89a12560495917813c7d183da60c21cce7b"
    sha256 sonoma:        "d1753b8276aadc6a66fc34f56a2fd5ce9579e183fe1a0a1767fd06b5c0a9dc92"
    sha256 ventura:       "707390e3d5b6fe706149fd59fd86280c516768757daf3b8552fb1f61abe41f15"
    sha256 arm64_linux:   "738203080c24306d9e150bf798da8d611d4aa026b998646a94f764f9a088d143"
    sha256 x86_64_linux:  "255e49b74598babda42059eb0176a79d4a45f79704518fbc4a86deec9e4b2849"
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

  def install
    if OS.mac?
      ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__"

      # FIXME: `ssh-keygen` errors out when this is built with optimisation.
      # Reported upstream at https://bugzilla.mindrot.org/show_bug.cgi?id=3584
      # Also can segfault at runtime: https://github.com/Homebrew/homebrew-core/issues/135200
      if Hardware::CPU.intel? && DevelopmentTools.clang_build_version == 1403
        inreplace "configure", "-fzero-call-used-regs=all", "-fzero-call-used-regs=used"
      end
    end

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
