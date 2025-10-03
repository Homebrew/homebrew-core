class Jhead < Formula
  desc "Extract Digicam setting info from EXIF JPEG headers"
  homepage "https://github.com/Matthias-Wandel/jhead"
  url "https://github.com/Matthias-Wandel/jhead/archive/refs/tags/3.08.tar.gz"
  sha256 "999a81b489c7b2a7264118f194359ecf4c1b714996a2790ff6d5d2f3940f1e9f"
  license :public_domain

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6695433af5f3468402173a67b2de5d735712c095f4bdbe8701e6b2354b43c38f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "891f4ab79df46ae9c29264f4cedff94944b4864c60db72d0e22ee015a381f3dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71ace969a83c578f9c0c891286904fed354829f5cb0a44f9314e0d75972e615a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "355d4bae9c9af01078c7c52425ab63e562d6b648c070b0a80e7504367fad0be6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e1b0e10fee8f443caaa68cb131a4f1e073e006a1f944b07d58caae3320e6e82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "995000c4bad760394f3f48b3147ae6b9daee454c0b61d93ce24d9212d72b7aee"
    sha256 cellar: :any_skip_relocation, sonoma:         "7727656b5e0ea923e453169baa7231383c37b737c4db88efc621b5593184283c"
    sha256 cellar: :any_skip_relocation, ventura:        "1507b2155ce500002fc776d8c336cc687cb515d0186bd1a1f2215ca4361e17c8"
    sha256 cellar: :any_skip_relocation, monterey:       "8c2f978dcaaad8d009b1b700dece3f9f06f74bb1139f0223883e7e4683a3de10"
    sha256 cellar: :any_skip_relocation, big_sur:        "c05e7a3d19073edea0839214f4b35cc892b8b9fcaf74d589e16dcf3fd31dabe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1c46927009697d53acc508449ef4b8127be41cb030a7e0fddb15561fff516b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d662d7006eb88363b9c973252bc744915503dafa662ef2dc75d1892918101cc2"
  end

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp test_fixtures("test.jpg"), testpath
    system bin/"jhead", "-autorot", "test.jpg"
  end
end
