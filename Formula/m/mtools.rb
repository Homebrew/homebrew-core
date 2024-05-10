class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.43.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.43.tar.gz"
  sha256 "8866666fa06906ee02c709f670ae6361c5ac2008251ed825c43d321c06775718"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25c21ff761fa4af203f237a5174c4c1373444df45e0d5e05c0632a9e7cd4db24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6946726b6f5238ec05a1c2a85ba65a1507931b226cb63fe79d08c94db0ef8fce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f40b6a8e2d129333a965130847c292716c7a08e633df9df8b46e1e5d81da74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc707c15ffed6999a1a81b958c4be06dec46f3f4580f1674e6882d05358892e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "571e4981449720fed19791a2ec62243e66861c3a0d8b2b2fdd731faefec15246"
    sha256 cellar: :any_skip_relocation, ventura:        "89d9b40ea5c5f459ee195f901d7ffbf5c71a79f61e0b162ae2f7a9b991006106"
    sha256 cellar: :any_skip_relocation, monterey:       "a87230228ab7202f1c2783a61f44cc181410b13ae28b3dfbbefafd42f74ccdf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "836180a06215fa9ed8bd6209d584e32ba5fc7c3af47ca18d77174726f2486a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93f8d6a77bf0b27c00544a980919da2a383b0aec7ac280395b019bb3e6dcb78c"
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
