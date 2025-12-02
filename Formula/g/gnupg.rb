class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.8.tar.bz2"
  sha256 "b58c80d79b04d3243ff49c1c3fc6b5f83138eb3784689563bcdd060595318616"
  license "GPL-3.0-or-later"

  # GnuPG appears to indicate stable releases with an even-numbered minor
  # (https://gnupg.org/download/#end-of-life).
  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "62d45b532e647eb6caedd018bc29e24d009e4c6b14613c5e5fd57c4a8514f424"
    sha256 arm64_sequoia: "7203b8a0af43aa4593cfc22e4152bd9331c35ba68450240353c2365e41d29895"
    sha256 arm64_sonoma:  "f659c9e637d2c2932ec0402c2a334df0b019d2150b0e78810a9bab06adf82dc8"
    sha256 arm64_ventura: "96233a9abeb43d4c4b14fcdd6e49e573f7799fc73ea6d4d91f1cd0ddfdbf46ae"
    sha256 sonoma:        "bccb362c8eeb1f56f7b3fee1982ef890d1f0ff92018b7feb8c4182191cbe0113"
    sha256 ventura:       "d18a1dc39de9890030ece85ae3df0497defdfbb8422385a3ef75455e8c82680a"
    sha256 arm64_linux:   "4095b433173396ad34343f81f749ac26313f42287952da334283eb8b25c83116"
    sha256 x86_64_linux:  "18c50e87640a9bed50bdc7a8fe579697965e5fd939ba5f180da9e4bc2e808977"
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
  uses_from_macos "sqlite"
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
