class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.7.tar.bz2"
  sha256 "7b24706e4da7e0e3b06ca068231027401f238102c41c909631349dcc3b85eb46"
  license "GPL-3.0-or-later"

  # GnuPG appears to indicate stable releases with an even-numbered minor
  # (https://gnupg.org/download/#end-of-life).
  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "47b40c87309680baa445bb8b9bb71c94f7c9020789a6ae5f45980febeb6d1e42"
    sha256 arm64_sonoma:  "f2778e812043b14964316eaaa17bc8fde02331fea2746af82bd5694d93456710"
    sha256 arm64_ventura: "7f2f1d42257dc87ee46240ae4ea8eff46455245fdf832b905d52d8364e08da2c"
    sha256 sonoma:        "989a2348d01b160110ab4ba3bedda4e194bf02122d31e6029fc536baba261a37"
    sha256 ventura:       "1b8bfec784f857856a2471ed8702259987fab15b101f9d948c81467b0fd5bc91"
    sha256 arm64_linux:   "034b0c4e1ae9be164ee043455e873e37be5ff47d0d36b5289de8962095df9039"
    sha256 x86_64_linux:  "a091d36b710f7fdd8db5cb20dc4af2f20254b04f3d17fd2df2155701e0da9d27"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  depends_on "libusb"
  depends_on "npth"
  depends_on "pinentry"
  depends_on "readline"

  uses_from_macos "bzip2"
  uses_from_macos "openldap"
  uses_from_macos "sqlite", since: :catalina
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  conflicts_with cask: "gpg-suite"
  conflicts_with cask: "gpg-suite-no-mail"
  conflicts_with cask: "gpg-suite-pinentry"
  conflicts_with cask: "gpg-suite@nightly"

  def install
    libusb = Formula["libusb"]
    ENV.append "CPPFLAGS", "-I#{libusb.opt_include}/libusb-#{libusb.version.major_minor}"

    mkdir "build" do
      system "../configure", "--disable-silent-rules",
                             "--enable-all-tests",
                             "--sysconfdir=#{etc}",
                             "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry",
                             "--with-readline=#{Formula["readline"].opt_prefix}",
                             *std_configure_args
      system "make"
      system "make", "check"
      system "make", "install"
    end

    # Configure scdaemon as recommended by upstream developers
    # https://dev.gnupg.org/T5415#145864
    if OS.mac?
      # write to buildpath then install to ensure existing files are not clobbered
      (buildpath/"scdaemon.conf").write <<~CONF
        disable-ccid
      CONF
      pkgetc.install "scdaemon.conf"
    end
  end

  def post_install
    (var/"run").mkpath
    quiet_system "killall", "gpg-agent"
  end

  test do
    (testpath/"batch.gpg").write <<~GPG
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    GPG

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
