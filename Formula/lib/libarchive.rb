class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.8.7.tar.xz"
  sha256 "d3a8ba457ae25c27c84fd2830a2efdcc5b1d40bf585d4eb0d35f47e99e5d4774"
  license "BSD-2-Clause"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6dd837cfe2574394e0b6ac94f950494fb2c72b58d5fa71c148ef56e73e5572c2"
    sha256 cellar: :any,                 arm64_sequoia: "13c01e35802a67dd5c6497c040fb20cf907c3d9f47e7db1ccd09d4886c37ff10"
    sha256 cellar: :any,                 arm64_sonoma:  "433ebd552c500dcc7149f06938f9b1060a23524effbd2340af60ce7b476d86d2"
    sha256 cellar: :any,                 sonoma:        "fe115f93461150d1675b4a2e083d56fd9f4ca5ae540602cdcd03f5763b9c0b50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73180a2fa205a6eef1c1f2247c0626c9aab8f608a83dcbe35abd2d6ceba3b064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7570673c30f9ce3ff322d5f4474b6062dd36e8189907e3d131e58cffebba2da1"
  end

  keg_only :provided_by_macos

  depends_on "libb2"
  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = [
      "--without-lzo2",    # Use lzop binary instead of lzo2 due to GPL
      "--without-nettle",  # xar hashing option but GPLv3
      "--without-xml2",    # xar hashing option but tricky dependencies
      "--without-openssl", # mtree hashing now possible without OpenSSL
      "--with-expat",      # best xar hashing option
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Avoid hardcoding Cellar paths in dependents.
    inreplace lib/"pkgconfig/libarchive.pc", prefix.to_s, opt_prefix.to_s

    return unless OS.mac?

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
