class GnupgAT22 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.45.tar.bz2"
  sha256 "d1abecd2b6c052749fd5748ba9de7021567e06b573dc6becac8df25cb87500e8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "8d5d196f730de5750668c544a89072f9b49f4c1e50b789febfef6dfa45737732"
    sha256 arm64_sonoma:  "95e6b4de9833631f8edabe5e884f361064868fdd53cedc77270c44c5cff92fb9"
    sha256 arm64_ventura: "cf4903d0310a509ca89a0006a0829fd43ab0eb6437d25edcd3a8d791415fa18e"
    sha256 sonoma:        "0ab0b520cf2c9fe7dda0fc685e109690ec4cf42c048d99032f153f9e4c57cc9f"
    sha256 ventura:       "669f53703809aeeb18bf20d7412273752a0fe10d1e9c2e7613ce05d530177b94"
    sha256 arm64_linux:   "8b1e5bb872380adc2e2f51ad64405bdd55cd21c8c0cf6a5d1f1b3027e307b8b5"
    sha256 x86_64_linux:  "53dff7529ced678aceb1d72fad1ece04b9154b9de0b3dcc24f03dab9abed018a"
  end

  keg_only :versioned_formula

  disable! date: "2025-04-01", because: :versioned_formula

  depends_on "pkgconf" => :build
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

    system "./configure", "--disable-silent-rules",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--enable-all-tests",
                          "--enable-symcryptrun",
                          "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry",
                          *std_configure_args
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
