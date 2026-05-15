class Gnupg < Formula
  desc "GNU Privacy Guard (OpenPGP)"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.5.20.tar.bz2"
  sha256 "6461266e99c308419a379abe6c356d54c214136c4589bd65951091138989ffc6"
  license "GPL-3.0-or-later"
  compatibility_version 1

  # GnuPG usually indicates stable releases with an even-numbered minor but
  # can declare an odd-numbered minor stable. e.g. 2.5 was stable since 2.5.16,
  # see https://lists.gnupg.org/pipermail/gnupg-announce/2025q4/000500.html.
  # The livecheck scrapes the version from the templated homepage which is
  # manually updated by upstream when a new release series is stable, e.g.
  # https://dev.gnupg.org/rD18a889b403c7a5934d5080be140a4d79e1c83332
  livecheck do
    url :homepage
    regex(/The current version of GnuPG is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    sha256 arm64_tahoe:   "97b693dac83b61c9e6e3ec51c2a2dd8e22c70cd51e50aa334bfc64b693005839"
    sha256 arm64_sequoia: "3af7e31aa9d7b338fb5d5829452b66fa303f5914fcb1a974106107a8fa1915e4"
    sha256 arm64_sonoma:  "2fbb4e6a008b159b9733e7e374aaab0d84f94c9d813703a880a04e6f345e24db"
    sha256 sonoma:        "4bcfb0d2cae7c2135fa9049731e2b838b27ba40e2634bba417f5dedd89f6b448"
    sha256 arm64_linux:   "171fa43da17a222d11cd0c3d826604335df0fe831c6151047ce669f4b2580366"
    sha256 x86_64_linux:  "8968cbe8875ec54539111c9b25e1aff019f72d0ac942f151a7ed4419ad2214d5"
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

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
