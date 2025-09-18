class Diction < Formula
  desc "GNU diction and style"
  homepage "https://www.gnu.org/software/diction/"
  url "https://ftpmirror.gnu.org/gnu/diction/diction-1.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/diction/diction-1.11.tar.gz"
  sha256 "35c2f1bf8ddf0d5fa9f737ffc8e55230736e5d850ff40b57fdf5ef1d7aa024f6"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "abe65914558d009a92abe38d0c86b41936e724e53ec3d3045ff5b2f37be7cf4c"
    sha256 arm64_sequoia:  "6516cc7161c82d0f8db43cc8feb42dfac2f946e632c76432cb7ed00fde3fe078"
    sha256 arm64_sonoma:   "4589af49e9b3cd23f77eae06ba86dadb9b364ca88e1714b3aa4b2f169df49321"
    sha256 arm64_ventura:  "9a0b3b7dd6f41245ff193e2bb23cb351d0378fe4aab1bf5bc2be56e123c39f14"
    sha256 arm64_monterey: "183609551d3baeef5692cfffda8251eda4e2586d5ce26db40a1c0c1a9d6e8a14"
    sha256 arm64_big_sur:  "88a87488f8e893dc86f30e8736cf9cbdc2459976da13d899cb91daf8abdfe23e"
    sha256 sonoma:         "53e52bc08853b0e471fd5393c12937106de73760b40611cab468e2eae2fcf260"
    sha256 ventura:        "600f2890074435296fd68c07bb8cbcd69c3cee3f4bdf84fcfbd7c508e075da43"
    sha256 monterey:       "3ac10ac27b2fd8d0c961b256577a52eeb6bf5a8afce04afdc9c39d5a1403ae32"
    sha256 big_sur:        "cf3b827429c5513b3289ab9c0df46de743cf84c773102a2f01058c982721e4cc"
    sha256 catalina:       "ff26ae017482eaef3a07b4c6522e65a84b2ec03b6afaffa20e0138a244edd5e2"
    sha256 arm64_linux:    "e73e21df8df919d01becb9b68654ec8b483dbb31207e4685f0b126b8d56c30de"
    sha256 x86_64_linux:   "fa36156d5d431720a8bc0c8b05a1681e9231cfce822b2b012c602fa1a8e3e159"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    file = "test.txt"
    (testpath/file).write "The quick brown fox jumps over the lazy dog."
    assert_match(/^.*35 characters.*9 words.*$/m, shell_output("#{bin}/style #{file}"))
    assert_match "No phrases in 1 sentence found.", shell_output("#{bin}/diction #{file}")
  end
end
