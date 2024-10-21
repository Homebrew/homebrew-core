class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.7.7.tar.xz"
  sha256 "879acd83c3399c7caaee73fe5f7418e06087ab2aaf40af3e99b9e29beb29faee"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "faa2ce394a18275219d6962a94b179069c03e4984def0e50c1b24299faf6c241"
    sha256 cellar: :any,                 arm64_sonoma:  "aae3b625c55b90350442f6e875d0dcc581d06fe55deee5d130e3cb62796218b7"
    sha256 cellar: :any,                 arm64_ventura: "f958d5c4d48d485952127f8bd60c58340584ddca04224c494030d80ab1d52b88"
    sha256 cellar: :any,                 sonoma:        "2826ca154e5d77a3359b452fd1474a40440bd31a3fe2e271c2ec126be18db5ef"
    sha256 cellar: :any,                 ventura:       "ff075171bb4be50191aefefc74f279c47d45a545216b2e867adeab60a9e0e809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64931b9a1e34e7e1085ef0c61879c7a599d7d18bf642f6b6c1804cb20ff2b8bf"
  end

  keg_only :provided_by_macos

  depends_on "libb2"
  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
           "--without-lzo2",    # Use lzop binary instead of lzo2 due to GPL
           "--without-nettle",  # xar hashing option but GPLv3
           "--without-xml2",    # xar hashing option but tricky dependencies
           "--without-openssl", # mtree hashing now possible without OpenSSL
           "--with-expat"       # best xar hashing option

    system "make", "install"

    # Avoid hardcoding Cellar paths in dependents.
    inreplace lib/"pkgconfig/libarchive.pc", prefix.to_s, opt_prefix.to_s

    return unless OS.mac?

    # fixes https://github.com/libarchive/libarchive/issues/1819
    inreplace lib/"pkgconfig/libarchive.pc" do |s|
      s.gsub! "Libs.private: ", "Libs.private: -liconv "
      s.gsub! "Requires.private: iconv", ""
    end

    # Just as apple does it.
    ln_s bin/"bsdtar", bin/"tar"
    ln_s bin/"bsdcpio", bin/"cpio"
    ln_s man1/"bsdtar.1", man1/"tar.1"
    ln_s man1/"bsdcpio.1", man1/"cpio.1"
  end

  test do
    (testpath/"test").write("test")
    system bin/"bsdtar", "-czvf", "test.tar.gz", "test"
    assert_match "test", shell_output("#{bin}/bsdtar -xOzf test.tar.gz")
  end
end
