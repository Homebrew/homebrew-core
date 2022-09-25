class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.41.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.41.tar.gz"
  sha256 "0816539dd3784fdf622de90aa5459d7c897584d69930a076b38fc4e975bd63d3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "085c4b7f17ed17af2e5e6dddf2c1ea81d55e6204767f20ea0b915b1ef8fd2aec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5614e6d5a58314387a1fc66d267c34e3491b28a584a8b781ea8db3e3cb749b57"
    sha256 cellar: :any_skip_relocation, monterey:       "08a81f09374540bbbd2a64716da7b16b8bf277fee21b9774a4c9f4f848d733a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0ceb747c1cd82bf997203d1f3381c9f6947faab6ba00c3df62eabb13d6a2584"
    sha256 cellar: :any_skip_relocation, catalina:       "39bf7b0d33eae404fd7f5abd21b6a5c59d562e21226a6902ea8ad880828d48d5"
  end

  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --without-x
    ]
    args << "LIBS=-liconv" if OS.mac?

    # The mtools configure script incorrectly detects stat64. This forces it off
    # to fix build errors on Apple Silicon. See stat(6) and pv.rb.
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtools --version")
  end
end
