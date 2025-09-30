class Imagejs < Formula
  desc "Tool to hide JavaScript inside valid image files"
  homepage "https://github.com/jklmnn/imagejs"
  url "https://github.com/jklmnn/imagejs/archive/refs/tags/0.7.2.tar.gz"
  sha256 "ba75c7ea549c4afbcb2a516565ba0b762b5fc38a03a48e5b94bec78bac7dab07"
  license "GPL-3.0-only"
  head "https://github.com/jklmnn/imagejs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "8300352570ea600d8dc4c6d8de40b4aa30a182db569bd3a2bb213b3d4ae92193"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e63b962d504ec008aa03bbbc391604e5ade5d25d0316d1b040cc053a56b2821f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99187a2855b722b5b1e50cce08e0c12c22ee803f6420ea15c96852b2be06dac1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e76ab06468439a91138e802c3da8aa8d422a659aebb2abc94fea8a8f576d0b71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1297a2272e34c7bd91997cb8ec161fac1694089d5e4daeaa2a9377714e197d38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f03279a8e5c316d74b2b93939714aa16dc624735ca8bda89b20468bc346c4216"
    sha256 cellar: :any_skip_relocation, sonoma:         "56cdc1042a0b27737d8c42c9c9edd9f4d704c17330f28a27958013c1bffd6991"
    sha256 cellar: :any_skip_relocation, ventura:        "e2ad3d26c4cf47649428a26612ebf2db567717311fac840f894526c52efc423a"
    sha256 cellar: :any_skip_relocation, monterey:       "8cd267264a5a90805ce6271406f149e6401f04e851243bf89b6ec70a2975cc92"
    sha256 cellar: :any_skip_relocation, big_sur:        "99e906e8eeb8451f8c2f8408aa990cddb575a02be4cdc5d4ea3f95362d040633"
    sha256 cellar: :any_skip_relocation, catalina:       "7bddae8dab41f73bce7acb3c86a6dc01dcd3edeb5e0abf80b155e498372b8e5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "372fb4580d7b15c0016508a244d85e66c675fe74b152d9864a9cf5a249bc3aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bda97ebfc90e0131fce362fa01a10bce43ab5cc1ee0080d260483b2902e88d4"
  end

  def install
    system "make"
    bin.install "imagejs"
  end

  test do
    (testpath/"test.js").write "alert('Hello World!')"
    system bin/"imagejs", "bmp", "test.js", "-l"
  end
end
