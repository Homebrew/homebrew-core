class Gnupg < Formula
  desc "GNU Privacy Guard (OpenPGP)"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.5.19.tar.bz2"
  sha256 "722aa8a426dd9b44e0d194b73bfee3a3e617d65674cd4d1d062e6df29f1788c6"
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
    sha256 arm64_tahoe:   "ff7232227267e0775047fa476eae5abcb70398b20998a593b37bccbbf2b7fca0"
    sha256 arm64_sequoia: "4d807274251687efe777fbb33f79324d414481d5dd4e8992147fecc6897e9ae3"
    sha256 arm64_sonoma:  "b15893211a4a4c7f0c77ed85454f8aa46152ed1889607c062ba05f7e0d1cbbf5"
    sha256 sonoma:        "73bb2f70928b8339a61e90d3df7c4e98d1be74806c443c3a188ba3df2641acde"
    sha256 arm64_linux:   "6f5aa9c77560ea4588ce21ffc801bbf9448e9144fdc20f7d85909003ded515ab"
    sha256 x86_64_linux:  "dc0fe11d7bb41789184bee1a98e5225c1ce232b9e0b0dfd07f3b47f6cf4350bd"
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
