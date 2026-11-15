class Gnupg < Formula
  desc "GNU Privacy Guard (OpenPGP)"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.5.24.tar.bz2"
  sha256 "bf149d01a2b9fcc0e4589b8ae8697d3d5c557ea48ed95a3fa55dd3b1187e6039"
  license "GPL-3.0-or-later"
  revision 1
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
    sha256 arm64_golden_gate: "1cbc3ab22b562d1bef04ca0d00b0917195870a80b6a7de1051d07c1b44ac75c0"
    sha256 arm64_tahoe:       "16b53990074dfe23dbe2342a548e8b72a91a5697c522d1eef3410fe8be5c1e0a"
    sha256 arm64_sequoia:     "91163072d2759706aa41c014bc865019900eaa815ab5bd017263ab059694addf"
    sha256 arm64_linux:       "12e8cda7299a624bd92f45f63284ac527ff07bcbcf7d7107e76a5ff77cefa7f2"
    sha256 x86_64_linux:      "3f5c7667ecc9b2d6342eab1a69b4e8f16faace4e536d3f60c5653b939cd5c5c6"
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

  # Fix import of unprotected ECDH secret keys, a regression in 2.5.23
  patch do
    url "https://github.com/gpg/gnupg/commit/42386bcf8861f04c1bdec5cbb139a03da83d8ef9.patch?full_index=1"
    sha256 "93817449be3f93dcade3d79960e33e72959f54f95ff6108f22176bef28111f2b"
    type :backport
    resolves "https://dev.gnupg.org/T8469"
  end

  patch do
    url "https://github.com/gpg/gnupg/commit/5523cec6913bcbd1a374d183899a6f298d2c0e32.patch?full_index=1"
    sha256 "0a0acd2f7f25723f3f84ec5c4ecf03b786d73ca61c48487d4d00c0559be89d66"
    type :backport
    resolves "https://dev.gnupg.org/T8469"
  end

  deny_network_access!

  def install
    libusb = Formula["libusb"]
    ENV.append "CPPFLAGS", "-I#{libusb.opt_include}/libusb-#{libusb.version.major_minor}"

    # gpgscm otherwise hard-codes /tmp on Unix.
    inreplace "tests/gpgscm/tests.scm", "(get-temp-path)", '(getenv "TMPDIR")'

    mkdir "build" do
      system "../configure", "--disable-silent-rules",
                             "--enable-all-tests",
                             "--sysconfdir=#{etc}",
                             "--with-pinentry-pgm=#{formula_opt_bin("pinentry")}/pinentry",
                             "--with-readline=#{formula_opt_prefix("readline")}",
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

  post_install_steps do
    mkdir_p "run", base: :var
    terminate_process "gpg-agent", must_succeed: false
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
