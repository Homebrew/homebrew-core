class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.45.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.45.tar.gz"
  sha256 "eea170403f48f0cd19b3d940e4bd12630a82601e25f944f47654b13d9d7eb5d4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4534b28c0164c15e724ef0a5cdb3256b793208d4380488872b771efefd4481f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a69d244619ed51e4bdcd2a2c54ba7a712a941cb73790402bd230e84d2cdf6fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31caad0f48bc1783fe12de78b091f03b42553a4155cc1a05f0ef8f1e38d389cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "92902b9fd9f243b4490d0e4e3ce9cb2840598ddc99d9d7b36c791a6f8a31aaab"
    sha256 cellar: :any_skip_relocation, ventura:       "22851f50c2d8e4c30255ec3a8459d33328336c2e905bc619b9354920011a0d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "283a14c5bb3d469b129bccef5cb217b6b96a0a729db36b47df2c6d96ffc55660"
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
