class GnupgAT22 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.40.tar.bz2"
  sha256 "1164b29a75e8ab93ea15033300149e1872a7ef6bdda3d7c78229a735f8204c28"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(2\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "509c767f63efee9557d507b4651155cc87daae47a8fdc58df2030cac6c8a7fec"
    sha256 arm64_big_sur:  "fdcdd0dfbb313846d86c0ff0c1062f5568663efc7d7ea3f41661e8a996862503"
    sha256 monterey:       "14699c2d17414dfe1a74e54466aabdacf770c24f47f32953586be223b0fe3ca4"
    sha256 big_sur:        "39e27c52176d3e971dbd627464dbd354dfe83726e9c35dbdbc807dd2da8f9e8e"
    sha256 catalina:       "e906301a6d3a7b12e2462710e243ed2f4da67f80495962825c488ecbf2ea6e5b"
    sha256 x86_64_linux:   "861e9de9f4c52fb0cf499e5028f2880fda6f087d54f3e41714ca88d631758aef"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  depends_on "libusb"
  depends_on "npth"
  depends_on "pinentry"

  uses_from_macos "sqlite" => :build

  on_linux do
    depends_on "libidn"
  end

  # Fixes a build failure without ldap.
  # Committed upstream, will be in the next release.
  # https://dev.gnupg.org/T6239
  patch do
    url "https://dev.gnupg.org/rGa5c3821664886ffffbe6a83aac088a6e0088a607?diff=1"
    sha256 "41c633362f599fdc5a3d3b49f70831854ac881273aafbbc568ae4e87f4121782"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--enable-all-tests",
                          "--enable-symcryptrun",
                          "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
    quiet_system "killall", "gpg-agent"
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      (testpath/"test.txt").write "Hello World!"
      system bin/"gpg", "--detach-sign", "test.txt"
      system bin/"gpg", "--verify", "test.txt.sig"
    ensure
      system bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
