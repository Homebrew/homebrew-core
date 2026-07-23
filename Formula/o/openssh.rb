class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "https://www.openssh.com/"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.4p1.tar.gz"
  mirror "https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.4p1.tar.gz"
  version "10.4p1"
  sha256 "ef6026dd2aea8d56059638d5d3262902c892ceba9f88395835e0d06d3fb63238"
  license "SSH-OpenSSH"
  compatibility_version 1

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/"
    regex(/href=.*?openssh[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "81e2f8242e1e3edf5560aafb6098ad129803394a96fdf4833130ac1af50ef450"
    sha256 arm64_sequoia: "eace489f554fa0c5c13547e1835ea7316f33f868bf3ffdc008c2009d25989648"
    sha256 arm64_sonoma:  "0ca3cd3d2b032537696eea6870aae3ab96a4e8316dde8a2ed6d06fa87270ecec"
    sha256 sonoma:        "0e3ca02fd9bbb424bcc5102f218753094ef9c49e9564a32b8049e204e8a0cb51"
    sha256 arm64_linux:   "ed903e1ae78db680111e7b964a9627f5dab51a6167e01d79f21fe66b8ac56826"
    sha256 x86_64_linux:  "d44c94f5cbb5a13cf1ce8f32be4db3733c178612e047aadac663d1a226ca48f0"
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

  def install
    ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__" if OS.mac?

    args = %W[
      --sysconfdir=#{etc}/ssh
      --with-ldns
      --with-libedit
      --with-kerberos5
      --with-pam
      --with-ssl-dir=#{formula_opt_prefix("openssl@3")}
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
