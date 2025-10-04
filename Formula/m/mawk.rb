class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20250131.tgz"
  sha256 "51bcb82d577b141d896d9d9c3077d7aaa209490132e9f2b9573ba8511b3835be"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "000c7e786c0898721626b361f24d36150d4bd78af31df136ab02c022385d7712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae1fe393d35cda1a41cbe812a9a947e52d14a8c3c5280578ecd8a5693e50e6ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2816a9a45edde2402da6af6788012f22c4a11ce5a27975bd7a104b8e1e7b3df5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87970558c84e6172003dfede622bf5fe3b78309f709a3c5a81dfcf2f8a44d24f"
    sha256 cellar: :any_skip_relocation, sonoma:        "056917eaa79d45b640add493c114d8e027cab6d5dbe954f1dd5cc5654b482f09"
    sha256 cellar: :any_skip_relocation, ventura:       "bec5bb0e31eb1bb02091352669b80053544c636cbfb591ba96ea57c5639abe8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e43b15161774ffd1beaa7373041268f90ec6f41ae1078ea01708d566e813bde8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a6fd86d47f102fd70685b287128bb0d7b71e1c1cb5814d4fdb31b674598b00a"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = pipe_output("#{bin}/mawk '#{mawk_expr}'", shell_output("#{bin}/mawk -W version 2>&1"))
    assert_equal version.to_s, ver_out
  end
end
