class Puf < Formula
  desc "Parallel URL fetcher"
  homepage "https://puf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/puf/puf/1.0.0/puf-1.0.0.tar.gz"
  sha256 "3f1602057dc47debeb54effc2db9eadcffae266834389bdbf5ab14fc611eeaf0"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ec01e1392c1d20a55a38aa3f02102a9687184966b760254a2fb280c37f48da73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "148adff9f4f307fc6b8a94bf5a5baa2c66dd8f3aee810c349a4cc3a356517d90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb2dd937eb2ae17b8c5abb9df4e2a8639c02dfce8ae5d6a78f26a51ec5104d44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ba1fc9eecb1a5920c6eadb88fe5c2142bafd356d420356f15afb0a923ef5b3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48d6dada2a26fdd71146a6e83b2cd5792af6a365804f5d714171eccbdcbcdc7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9daf26921e00b28187380efab232b5f4d4e02877e258ec6e4e204d446c25cf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "6341794aaef25ff32f718ae11389dea24c95da2ea7b6d0dc375b44f6d17cc829"
    sha256 cellar: :any_skip_relocation, ventura:        "34f663287a1e6eccd24478afff1260281cdca68dda5efa9a6211d1aebd6d425b"
    sha256 cellar: :any_skip_relocation, monterey:       "c1afcd4b99802518b7cee90c23225bec8d2d7104efa503c4115830ab51f582e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "590e0087a563c0fa38996f69c80316f95a54a3a788f0e07390ba192db1d67c44"
    sha256 cellar: :any_skip_relocation, catalina:       "cad4c55abee941651ac9e1f203041240aae43b990f3e9efdce7cd9e0342b727c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "94b07bacd92695fdd33ae7adc47e52dba95c837adf0ee6d653e0c5f564b414f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0dccb5f5a95571338a440abdc6df58db883ad1ce1b4a3ddc8bae95da82be9de"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--mandir=#{man}", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"puf", "-r", "example.com"
  end
end
