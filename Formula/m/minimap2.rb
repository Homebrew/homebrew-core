class Minimap2 < Formula
  desc "Versatile pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://lh3.github.io/minimap2"
  url "https://github.com/lh3/minimap2/archive/refs/tags/v2.28.tar.gz"
  sha256 "5ea6683b4184b5c49f6dbaef2bc5b66155e405888a0790d1b21fd3c93e474278"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "460b065b3c5d2574c09b7b6f2e20692574d77153b150e8161b0ec5cdd8450987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bfd4d2c1731ffbc45839fda3a405dfa930208b497c08de8f53770d4b942e690"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47cef6f5132e485823d26e03caba808de26301d29dff56a59d51006d00f5e4cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0a6571f41113568817ec781db7b4c9a31ac15fbe1aff96691dd04a6db12148d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7948260fe80260ff50ae0541174e6b404f8699f4b3ad1dfcaef7619fee42cd75"
    sha256 cellar: :any_skip_relocation, ventura:        "27681877ccc90d85eb51cfb7126d8b242998eb145eb985331f110cfaf8b81383"
    sha256 cellar: :any_skip_relocation, monterey:       "fcefb72704e3e02c7ce06c694cb6ff12d9d8d84983025e0e3e61a48358410e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca4b9be1d24ab45476ef3008a956aee3b4f62ebb5bf0172745928d04cce44e66"
  end

  uses_from_macos "zlib"

  def install
    if Hardware::CPU.arm?
      system "make", "arm_neon=1", "aarch64=1"
    else
      system "make"
    end
    bin.install "minimap2"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    output = shell_output("#{bin}/minimap2 -a MT-human.fa MT-orang.fa 2>&1")
    assert_match "mapped 1 sequences", output
  end
end
