class Daemon < Formula
  desc "Turn other processes into daemons"
  homepage "https://libslack.org/daemon/"
  url "https://libslack.org/daemon/download/daemon-0.8.2.tar.gz"
  sha256 "b34b37543bba43bd086e59f4b754c8102380ae5c1728b987c890d5da4b4cf3ca"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?daemon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67168d0e776fca5e0e6c2978c744e114ed90ba1555262d645e5f1a79ae844b3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bb7cbcb55ae6142dc315b12243d5bdbc75d7cb26a724233ab4ab4d56f6cc7bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c909f0b70f33ca40fcf32af53f16c9578f1155610a2ecdf0eed200d82a1ecaed"
    sha256 cellar: :any_skip_relocation, ventura:        "9d82ecab6f3639a579a82698613d536d7a5081ebb7fa043002d35ffb2b2ca779"
    sha256 cellar: :any_skip_relocation, monterey:       "6d699c3e932cf93485868577a79bbbd3fa67eaaea6d536923d07211306c22f0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "85e794a262a2f956b7b17c862840516b274a3c99402e5d6597d085868d8efdd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "584fe06d9ec4dc1a7a47c54407a1e88421ae6ea40282f56d74e00bef6228f8f1"
  end

  def install
    system "./configure"
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/daemon", "--version"
  end
end
