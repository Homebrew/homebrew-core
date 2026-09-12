class Gnupg < Formula
  desc "GNU Privacy Guard (OpenPGP)"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.5.22.tar.bz2"
  sha256 "96e27b020ad26510388e06f5f07f3f70a4ed8916ee995f1b72b7a024e6d9d87e"
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
    rebuild 1
    sha256 arm64_golden_gate: "23c218fe13f49e5410a151b46b3db9864b7b416f8f62218adc8e8ecf9fe07bbf"
    sha256 arm64_tahoe:       "ce8657136dfd5782c9dd0dcde21edf739db4391a02df0105a499309f40823ab5"
    sha256 arm64_sequoia:     "100bcea709850d9e2ac71afe515aeb78f62fa2be69289a8f2de59d9aa3023743"
    sha256 arm64_linux:       "18b3d53cf6758772229953f6dfb5c6e3a8c0abb1b79b59258f43821a43566d1f"
    sha256 x86_64_linux:      "3d39661c4e7cca8c23b88fcb8b120e00685185a18d6fef5c4e7ee95a22a1a171"
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

  def install
    libusb = Formula["libusb"]
    ENV.append "CPPFLAGS", "-I#{libusb.opt_include}/libusb-#{libusb.version.major_minor}"

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
