class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.7.9.tar.xz"
  sha256 "ed8b5732e4cd6e30fae909fb945cad8ff9cb7be5c6cdaa3944ec96e4a200c04c"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "237ddde1af210e9168d6a681dd3f96370f7a19eba17af214b099b4dbf9cda0b1"
    sha256 cellar: :any,                 arm64_sonoma:  "a475e438093c6505e53fff1ad3e82f532c2b2adcc59db02e799ecbffa5247058"
    sha256 cellar: :any,                 arm64_ventura: "65a9834753334f5bd18f742eee279941621ae35401380f9ccf9c1124358202de"
    sha256 cellar: :any,                 sonoma:        "7b661a676a926cdc8d2154d4ac64a7b8124ab9c56ba16b8e4a20fb8b8dc9c507"
    sha256 cellar: :any,                 ventura:       "5d8c93941f22f60f2ac5785c1bba35f2679851907e85e3216ff3f5ba1b7a42e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32a7c58ea92157c4aa069ca4c70385fb52dd40534cd0872c073462c3bcc4161a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1dbe4a7b46dfb122975676b7e69936ef36156c41ddb759742134e2afcdd932b"
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
