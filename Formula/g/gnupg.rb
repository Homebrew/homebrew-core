class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.5.tar.bz2"
  sha256 "f68f7d75d06cb1635c336d34d844af97436c3f64ea14bcb7c869782f96f44277"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "eead9f697214f8c9245ca7cb24aecff0ca3e8f46322ddf890c89146396782bc0"
    sha256 arm64_ventura:  "e096a8063b3cfbb76deb3afcba2ab5556a6403ca4c31bc1d1683edd3ad77fb70"
    sha256 arm64_monterey: "8e7c0ff2b1a73454e093b384aafb71a021c31049219dd4b55fd188a6574fa51e"
    sha256 sonoma:         "10a786c7b9f9eac5c960d303076ea31e1b62e6dd03168948ac6ee32752f97967"
    sha256 ventura:        "5bf0ac220534eb57328b643cefc17b31d3457e5a3bc0fbad53587e86412c4caa"
    sha256 monterey:       "6491443b90accbc12ad485d13025fc60d4d5a56e4f4d09e99fe3767f53c3d2b5"
    sha256 x86_64_linux:   "2701069f114e5a3b6b10ce4e6a34bb6df0edcbafdc4a4a7edc69208983d9109f"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  depends_on "libusb"
  depends_on "npth"
  depends_on "openldap"
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
