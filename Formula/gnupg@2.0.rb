class GnupgAT20 < Formula
  desc "GNU Privacy Guard: a free PGP replacement"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.0.31.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.31.tar.bz2"
  sha256 "095558cfbba52fba582963e97b0c016889570b4712d6b871abeef2cf93e62293"

  bottle do
    sha256 "32c8568804d669b19884c3d29efeb9abbcaa877571e587d33e14c8a8a2ebcbba" => :high_sierra
    sha256 "b547da420d75ad03b0c60826c96c1959432f363e9a0ab8d270ade56909a9d95b" => :sierra
    sha256 "f0b436938f9a17459d2ca4a30a80e9c68aa86547fbb7e36c0a2176e38da6188c" => :el_capitan
    sha256 "0b8eebc7065e3cd00c1cfa60012f390a9a24477e94ef8d7b4b762afa151c2103" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "libassuan"
  depends_on "pinentry"
  depends_on "pth"
  depends_on "gpg-agent"
  depends_on "curl" if MacOS.version <= :mavericks
  depends_on "dirmngr" => :recommended
  depends_on "libusb-compat" => :recommended
  depends_on "readline" => :optional

  def install
    # Adjust package name to fit our scheme of packaging both gnupg 1.x and
    # 2.x, and gpg-agent separately, and adjust tests to fit this scheme
    inreplace "configure" do |s|
      s.gsub! "PACKAGE_NAME='gnupg'", "PACKAGE_NAME='gnupg2'"
      s.gsub! "PACKAGE_TARNAME='gnupg'", "PACKAGE_TARNAME='gnupg2'"
    end
    inreplace "tests/openpgp/Makefile.in" do |s|
      s.gsub! "required_pgms = ../../g10/gpg2 ../../agent/gpg-agent",
              "required_pgms = ../../g10/gpg2"
      s.gsub! "../../agent/gpg-agent --quiet --daemon sh",
              "gpg-agent --quiet --daemon sh"
    end

    ENV.append "LDFLAGS", "-lresolv"

    ENV["gl_cv_absolute_stdint_h"] = "#{MacOS.sdk_path}/usr/include/stdint.h"

    agent = Formula["gpg-agent"].opt_prefix

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sbindir=#{bin}
      --enable-symcryptrun
      --disable-agent
      --with-agent-pgm=#{agent}/bin/gpg-agent
      --with-protect-tool-pgm=#{agent}/libexec/gpg-protect-tool
    ]

    if build.with? "readline"
      args << "--with-readline=#{Formula["readline"].opt_prefix}"
    end

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
    bin.install "tools/gpg-zip"

    # Add symlinks from gpg2 to unversioned executables, replacing gpg 1.x.
    bin.install_symlink "gpg2" => "gpg"
    bin.install_symlink "gpgv2" => "gpgv"
    man1.install_symlink "gpg2.1" => "gpg.1"
    man1.install_symlink "gpgv2.1" => "gpgv.1"
  end

  def post_install
    (var/"run").mkpath
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
      %commit
    EOS
    system bin/"gpg", "--batch", "--gen-key", "batch.gpg"
    (testpath/"test.txt").write "Hello World!"
    system bin/"gpg", "--armor", "--sign", "test.txt"
    system bin/"gpg", "--verify", "test.txt.asc"
  end
end
