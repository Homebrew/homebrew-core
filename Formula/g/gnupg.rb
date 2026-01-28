class Gnupg < Formula
  desc "GNU Privacy Guard (OpenPGP)"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.5.17.tar.bz2"
  sha256 "2c1fbe20e2958fd8fb53cf37d7c38e84a900edc0d561a1c4af4bc3a10888685d"
  license "GPL-3.0-or-later"

  # GnuPG indicates stable releases with an even-numbered minor tag, eg "gnupg26"
  # (https://dev.gnupg.org/T8007#210468, https://gnupg.org/download/#end-of-life)
  livecheck do
    url "https://versions.gnupg.org/swdb.lst"
    regex(/gnupg\d+[02468]_ver\s+(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8790cc919901b54d98374e720e1cfe11bd736349ed3b257022877cbbf28b7936"
    sha256 arm64_sequoia: "204bfd8654292c46f1d352443d0a63e1d96a666b20cf12540b2259a4a2718062"
    sha256 arm64_sonoma:  "ffbcb73787a436eb4e589fe9cf0c3d9dec783219496a8e32f185fc2835f29f21"
    sha256 sonoma:        "58b2c24d50feab827f59e9ff39dfc24abc556ce215362af2e748b5b649dd7179"
    sha256 arm64_linux:   "3fc62b49819678650756ab690b94ad8c93b560cbfc37f6e60ad76856d047d652"
    sha256 x86_64_linux:  "d827c95a23f01c17c582082ec7b4d470ab4af3f44e95d6ffcdf1a076f3c62a35"
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

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "bzip2"
    depends_on "sqlite"
    depends_on "zlib"
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
    quiet_system bin/"gpgconf", "--kill", "all"
  end

  test do
    gpg_flags = "--batch", "--passphrase", ""
    user_id = "test@test"

    begin
      system "test", "-x", "#{Formula["pinentry"].opt_bin}/pinentry"
      libreadline_ext = OS.mac? ? "dylib" : "so"
      system "test", "-f", "#{Formula["readline"].opt_lib}/libreadline.#{libreadline_ext}"
      system bin/"gpg", *gpg_flags, "--quick-gen-key", user_id, "pqc", "cert,sign", "never"
      fpr = `#{bin}/gpg --list-keys --with-colons #{user_id} | grep fpr | awk -F: '{print \$10}'`.chomp
      system bin/"gpg", *gpg_flags, "--quick-add-key", fpr, "pqc", "encr", "never"
      file = "test.txt"
      (testpath/file).write "test content"
      system bin/"gpg", *gpg_flags, "--encrypt", "--sign", "--recipient", user_id, file
      system bin/"gpg", *gpg_flags, "--decrypt", "#{file}.gpg"
    ensure
      system bin/"gpgconf", "--kill", "all"
    end
  end
end
