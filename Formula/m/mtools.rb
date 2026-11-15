class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftpmirror.gnu.org/mtools/mtools-4.0.50.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mtools/mtools-4.0.50.tar.gz"
  sha256 "7f078accae7551c6b3a316ccd8296357329f7bbbc09583dcd1a2bbaeb081a7a4"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00f0c85b01d488a9932455e5b7989191fad2c4839c889f2c934e21b901408bf7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9abaf0b9f5a39215bf8891e55783246cc1cbd306d9301662a933f6987284c872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "48e16e404b64817ba6b3339fb50b34dc90b22412b93e9f64958d97ded24ecd9b"
    sha256 cellar: :any,                 arm64_linux:       "8f1281b90d2bc0e52afff3f096193e56c6b228eb7ff000a239fc8067d11c108d"
    sha256 cellar: :any,                 x86_64_linux:      "375dec0bd49df495d77c90935b2536c4162a6f88274478431537f5a77a9b957c"
  end

  conflicts_with "mcat", because: "both install `mcat` binaries"
  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  deny_network_access!

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
