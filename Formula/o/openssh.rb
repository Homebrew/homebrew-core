class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "https://www.openssh.com/"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.6p1.tar.gz"
  mirror "https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.6p1.tar.gz"
  version "10.6p1"
  sha256 "a9dc9565dffe8640f64d863cd29a32bc4a3dbdec0566a7fc44c5d6ee767d5f39"
  license "SSH-OpenSSH"
  revision 2
  compatibility_version 1

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/"
    regex(/href=.*?openssh[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "287ee3dc00cd180182e7990c04fe25fc8440b99a8a4651605a087f4cc44b846b"
    sha256 arm64_tahoe:       "17a77da899577764c88b6dc20c8fe6a8d34391be63ddbab30c362f1bbfeb8fbe"
    sha256 arm64_sequoia:     "6e0423432f5ead4556420b0388ae4215133e81466baf633317c2de75d6c57842"
    sha256 arm64_linux:       "55e780dffc8ab67d6f7092fe3e8773369e7258f0168afde91c37ab3aabaaed42"
    sha256 x86_64_linux:      "9979138fd3cafb4248147005b65bdef8f3fec632e8a7db21a0bbc0ac9bd8fbe9"
  end

  # Please don't resubmit the keychain patch option. It will never be accepted.
  # https://archive.is/hSB6d#10%25

  depends_on "pkgconf" => :build
  depends_on "ldns"
  depends_on "libfido2"
  depends_on "openssl@4"

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

  allow_network_access! :test

  def install
    ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__" if OS.mac?

    args = %W[
      --sysconfdir=#{etc}/ssh
      --with-ldns
      --with-libedit
      --with-kerberos5
      --with-pam
      --with-ssl-dir=#{formula_opt_prefix("openssl@4")}
      --with-security-key-builtin
    ]

    args << "--with-privsep-path=#{var}/lib/sshd" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install-nokeys"

    # This was removed by upstream with very little announcement and has
    # potential to break scripts, so recreate it for now.
    # Debian have done the same thing.
    bin.install_symlink bin/"ssh" => "slogin"

    buildpath.install resource("com.openssh.sshd.sb")
    (etc/"ssh").install "com.openssh.sshd.sb" => "org.openssh.sshd.sb"

    # Don't hardcode Cellar paths in configuration files
    inreplace etc/"ssh/sshd_config", prefix, opt_prefix
  end

  post_install_steps do
    unless_path_exists "lib/openssh/host-keys-migrated-v1", base: :var do
      mkdir_p "lib/openssh/host-keys-backup", base: :var
      set_permissions "lib/openssh/host-keys-backup", "0700", base: :var, recursive: false
      if_path_exists "ssh/ssh_host_dsa_key", base: :etc do
        move "ssh/ssh_host_dsa_key", "lib/openssh/host-keys-backup",
             source_base: :etc, target_base: :var, overwrite: false
      end
      if_path_exists "ssh/ssh_host_dsa_key.pub", base: :etc do
        move "ssh/ssh_host_dsa_key.pub", "lib/openssh/host-keys-backup",
             source_base: :etc, target_base: :var, overwrite: false
      end
      if_path_exists "ssh/ssh_host_ecdsa_key", base: :etc do
        move "ssh/ssh_host_ecdsa_key", "lib/openssh/host-keys-backup",
             source_base: :etc, target_base: :var, overwrite: false
      end
      if_path_exists "ssh/ssh_host_ecdsa_key.pub", base: :etc do
        move "ssh/ssh_host_ecdsa_key.pub", "lib/openssh/host-keys-backup",
             source_base: :etc, target_base: :var, overwrite: false
      end
      if_path_exists "ssh/ssh_host_ed25519_key", base: :etc do
        move "ssh/ssh_host_ed25519_key", "lib/openssh/host-keys-backup",
             source_base: :etc, target_base: :var, overwrite: false
      end
      if_path_exists "ssh/ssh_host_ed25519_key.pub", base: :etc do
        move "ssh/ssh_host_ed25519_key.pub", "lib/openssh/host-keys-backup",
             source_base: :etc, target_base: :var, overwrite: false
      end
      if_path_exists "ssh/ssh_host_mldsa44_ed25519_key", base: :etc do
        move "ssh/ssh_host_mldsa44_ed25519_key", "lib/openssh/host-keys-backup",
             source_base: :etc, target_base: :var, overwrite: false
      end
      if_path_exists "ssh/ssh_host_mldsa44_ed25519_key.pub", base: :etc do
        move "ssh/ssh_host_mldsa44_ed25519_key.pub", "lib/openssh/host-keys-backup",
             source_base: :etc, target_base: :var, overwrite: false
      end
      if_path_exists "ssh/ssh_host_rsa_key", base: :etc do
        move "ssh/ssh_host_rsa_key", "lib/openssh/host-keys-backup",
             source_base: :etc, target_base: :var, overwrite: false
      end
      if_path_exists "ssh/ssh_host_rsa_key.pub", base: :etc do
        move "ssh/ssh_host_rsa_key.pub", "lib/openssh/host-keys-backup",
             source_base: :etc, target_base: :var, overwrite: false
      end
      touch "lib/openssh/host-keys-migrated-v1", base: :var
    end

    # create unique host keys
    run "ssh-keygen", args: ["-A"], base: :bin
  end

  def caveats
    <<~EOS
      Default host keys in #{etc}/ssh are regenerated once to replace keys
      previously distributed in bottles. This also replaces locally generated keys.

      Previous host keys are backed up in:
        #{var}/lib/openssh/host-keys-backup
      Restore them only if you generated them yourself.

      Restart any running Homebrew sshd to use the new host keys.
      SSH clients may report changed host keys. Verify the new fingerprints
      before updating their known_hosts entries.
    EOS
  end

  test do
    assert_empty (bottle_prefix/"etc/ssh").glob("ssh_host_*")

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
