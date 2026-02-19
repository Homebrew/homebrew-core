class Msieve < Formula
  desc "C library for factoring large integers"
  homepage "https://sourceforge.net/projects/msieve/"
  url "https://downloads.sourceforge.net/project/msieve/msieve/Msieve%20v1.53/msieve153_src.tar.gz"
  sha256 "c5fcbaaff266a43aa8bca55239d5b087d3e3f138d1a95d75b776c04ce4d93bb4"
  license :public_domain

  livecheck do
    url :stable
    regex(%r{url=.*?/Msieve%20v?(\d+(?:\.\d+)+)/}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7e5d447bbc245a2b91d8993937c87c8e559678ebd68f972905d6c11e0d2b29bf"
    sha256 cellar: :any,                 arm64_sequoia: "73413cbe23c21e464017e6abe5b7b10bf2e3e384e2e23f51dceef0be7bddc051"
    sha256 cellar: :any,                 arm64_sonoma:  "b35f5ce318727e40a0c2d540707475a883853effa8ea4c5214dec80f776b15ed"
    sha256 cellar: :any,                 sonoma:        "ca06f592fd7bc5ab600f422c05facec833296457fc5b9f511d80eae85b9537f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f469949e04536f662b6f3d7f8a4afdded9af65d7f4feefcb7fd9670dd92f3e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00366a1231d99d1ecb28d24e714467b1a5f4437504934d882fcb64fc35338ee5"
  end

  depends_on "gmp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.append "MACHINE_FLAGS", "-include sys/time.h"
    system "make", "all"
    bin.install "msieve"
  end

  test do
    assert_match "20\np1: 2\np1: 2\np1: 5", shell_output("#{bin}/msieve -q 20")
  end
end
