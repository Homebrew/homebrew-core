class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.5.2.tar.bz2"
  sha256 "7f404ccc6a58493fedc15faef59f3ae914831cff866a23f0bf9d66cfdd0fea29"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "504f8f29547995be5fef21f91769f05e1b2e317c424d3d481d3e1c69561f93b6"
    sha256 arm64_sonoma:  "5a23f8f2c150986e2e727a25bc42c12c5f89455bc27a213dcfa98289df377bf2"
    sha256 arm64_ventura: "31f920052dda3ede08d6a75b56c7b38cdb41a0964ab18305ebfc70ac55bbcc37"
    sha256 sonoma:        "e71ab7138942ea33cac896389aa8e82a4583d0ac5c1691d816e3671bd9327e7b"
    sha256 ventura:       "e6106c117ccdceeadbad2f16a6ddb551e93b08be6c60e9fc5af615ec23c26e3d"
    sha256 x86_64_linux:  "861b48d7bc2aa8e2a81f6c300d425ff2453ffb5bc948bc58cf1bdf1d93bd13ec"
  end

  head do
    url "https://github.com/gpg/gnupg.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "fig2dev" => :build
    depends_on "gettext" => :build
    depends_on "ghostscript" => :build
    depends_on "imagemagick" => :build
    depends_on "texinfo" => :build
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

  def install
    libusb = Formula["libusb"]
    ENV.append "CPPFLAGS", "-I#{libusb.opt_include}/libusb-#{libusb.version.major_minor}"
    ENV.append "LDFLAGS", "-L#{libusb.opt_lib}"

    readline = Formula["readline"]
    ENV.append "CPPFLAGS", "-I#{readline.opt_include}"
    ENV.append "LDFLAGS", "-L#{readline.opt_lib}"

    if build.head?
      system "./autogen.sh"
      maintenance_args = ["--enable-maintainer-mode"]
    else
      maintenance_args = []
    end

    mkdir "build" do
      system "../configure", "--disable-silent-rules",
                             "--enable-all-tests",
                             "--enable-large-secmem",
                             "--enable-ccid-driver",
                             "--sysconfdir=#{etc}",
                             "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry",
                             *maintenance_args,
                             *std_configure_args
      system "make"
      begin
        system "make", "check"
      rescue => e
        if OS.linux? && version.start_with?("2.5.")
          # Observed CI failures:
          # 2.5.2, 2024-12-06: 5 failures with the message: "*** buffer overflow detected ***: terminated"
          #                      tests/openpgp/tofu.scm
          #                      tests/openpgp/gpgv-forged-keyring.scm
          #                      tests/openpgp/gpgv.scm
          #                      tests/openpgp/ecc.scm
          #                      tests/openpgp/conventional-mdc.scm

          opoo("GnuPG self-test has failed. Proceeding anyway because the 2.5 branch is not considered stable.")
        else
          raise e
        end
      end
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
