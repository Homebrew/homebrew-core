class Bonniexx < Formula
  desc "Benchmark suite for file systems and hard drives"
  homepage "https://www.coker.com.au/bonnie++/"
  url "https://www.coker.com.au/bonnie++/bonnie++-2.00a.tgz"
  sha256 "a8d33bbd81bc7eb559ce5bf6e584b9b53faea39ccfb4ae92e58f27257e468f0e"
  license "GPL-2.0-only"

  livecheck do
    url "https://doc.coker.com.au/projects/bonnie/"
    regex(/href=.*?bonnie\+\+[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84fd1e486465aeb00c1a1f8c3820b336cfafef7867d4bccbdcc873d9ae596ec2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08e292d8b9ed4e96aa54ebc50f0fa67e43b2fc99ce817b8ba515861dbe7f8668"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ceed0542a0147c3b8a902aedd2c8bf87377a88f50ea65ba5da4c9e8faf85ee4"
    sha256 cellar: :any,                 arm64_linux:       "1ec4e0f867669e824aee81620de70aff90f4d59620b602cd8de354bcc6cd1db1"
    sha256 cellar: :any,                 x86_64_linux:      "ed2ec705d02407601e3709ded19555954d2cb1d0966efdc7260e4d14165e9fee"
  end

  # Remove the #ifdef _LARGEFILE64_SOURCE macros which not only prohibits the
  # intended functionality of splitting into 2 GB files for such filesystems but
  # also incorrectly tests for it in the first place. The ideal fix would be to
  # replace the AC_TRY_RUN() in configure.in if the fail code actually worked.
  patch do
    file "Patches/bonnie++/remove-large-file-support-macros.diff"
    type :unofficial
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system sbin/"bonnie++", "-s", "0"
  end
end
