class GnupgAT22 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.44.tar.bz2"
  sha256 "735b8b3e6d2330f66ab98336b060d5852a1a67cb2bc47ec7d1e5411577a8cadd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(2\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "ae04fa9bdd10750f7bf1a3d04c93228eba086a8a54efa222812cd8664a8aacc2"
    sha256 arm64_sonoma:   "a59f561a3a6fc4255ff5b78474a8eb8a0e2a85acd2324eea26b8d5825189f1d9"
    sha256 arm64_ventura:  "3a627f6f953e005d0dfa7849553a0b446f174c19f2efa5a28289a2e76112cd30"
    sha256 arm64_monterey: "a8902f2057eb44a5943166494dba399814f45fc8ff0681b1e15000a0378123aa"
    sha256 sonoma:         "27d7cb6a0b415c83a1be4eb618f907d862ed5ff6201be03866255ff9f211c9b1"
    sha256 ventura:        "06ab494804b1da7784aee8a385821b30e583ac257b8c4c89827db941ef285d54"
    sha256 monterey:       "378c0adda9293a26265a25e08a176e39ff0ef1f6ca72e85650063e1c684dc8fc"
    sha256 x86_64_linux:   "d6aa79c116ce67e2476a5fd3c95a7fa630f1ea8904ffac69d3418e6353a4ef8e"
  end

  keg_only :versioned_formula

  disable! date: "2025-04-01", because: :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  depends_on "libusb"
  depends_on "npth"
  depends_on "pinentry"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

  uses_from_macos "bzip2"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    libusb = Formula["libusb"]
    ENV.append "CPPFLAGS", "-I#{libusb.opt_include}/libusb-#{libusb.version.major_minor}"

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
