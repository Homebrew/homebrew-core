class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.0.tar.bz2"
  sha256 "1d79158dd01d992431dd2e3facb89fdac97127f89784ea2cb610c600fb0c1483"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6969503746990439b1bee07939dd9558aa41e9360b91173f30d8b53814bdeb87"
    sha256 arm64_monterey: "2097638d35ed8dbdb83634dc720880ec618dbf76e89fdbc28c46b6c3e7ba9998"
    sha256 arm64_big_sur:  "9f82c84919455dde032dc667a76ada4a443d22ad8309fd7d8fdbb3c36ee06515"
    sha256 ventura:        "441995baa0a9064600e0960e4ec1f77a4b7e8b96d83a4353941bfa6212f2ac04"
    sha256 monterey:       "46476571803c002aa14d7f8725db0bbc19784a253cf0498fee8c72966b032806"
    sha256 big_sur:        "1a727ceaf45887631eaaa4aa1a20c5c906e145ed8e0b145607452fe47a98dfb4"
    sha256 catalina:       "e82c083cee3b8c1bc5d9eddbd96ff1759f86b4190acd818b43db435304a03b01"
    sha256 x86_64_linux:   "c7b4f95f9dae0dcc96134a77a7272636ca4a21e4175dc6e5862109ff3bca2c8e"
  end

  depends_on "pkg-config" => :build
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
  uses_from_macos "sqlite", since: :catalina
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    libusb = Formula["libusb"]
    ENV.append "CPPFLAGS", "-I#{libusb.opt_include}/libusb-#{libusb.version.major_minor}"

    mkdir "build" do
      system "../configure", *std_configure_args,
                             "--disable-silent-rules",
                             "--sbindir=#{bin}",
                             "--sysconfdir=#{etc}",
                             "--enable-all-tests",
                             "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry"
      system "make"
      system "make", "check"
      system "make", "install"
    end

    # Configure scdaemon as recommended by upstream developers
    # https://dev.gnupg.org/T5415#145864
    if OS.mac?
      # write to buildpath then install to ensure existing files are not clobbered
      (buildpath/"scdaemon.conf").write <<~EOS
        disable-ccid
      EOS
      pkgetc.install "scdaemon.conf"
    end
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
