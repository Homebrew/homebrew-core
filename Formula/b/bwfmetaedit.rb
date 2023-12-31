class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/23.04/BWFMetaEdit_CLI_23.04_GNU_FromSource.tar.bz2"
  sha256 "25e2050c853bb5558a339610a527360c51cec9c8343c84d7723f022f3e6cb364"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97df9363f89d98e02dd081f999f8579371d4c4cea0178113a9cb12fb4e30327b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8d78adf4343b50ff735edf6ab4032a01635b9bc1869a9dd51f7051ccabdfd0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb6f807dcb8b73f26f941c87954a25e0c379b59d67bf32590d48991a888d640b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25abca1df21f70d6c40a631db16f94fd0a51ab6a555f7aaea2bb4eebb0d866f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1657843f41b5502afa2506d96ebdd4ef4132134eb31ae19e37a519ea3d89c51"
    sha256 cellar: :any_skip_relocation, ventura:        "6ff691c4626a4b82f1c0d02a744b762671627f399cc47dd82047d02b502f2e2b"
    sha256 cellar: :any_skip_relocation, monterey:       "33541498b7b7f1923be50ad5c47ffc7946ab0f6cec752e59967fc755de94fb54"
    sha256 cellar: :any_skip_relocation, big_sur:        "d56b37a65900c0bfa17bb20276bb561ab92f8f4c0488a4cfde3f5be9aff2bc26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1064614960a6c707fb087db9f3e8f5210ebb7f3e34d6a2badf582d2d3cb318ad"
  end

  def install
    cd "Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/bwfmetaedit --out-tech", test_fixtures("test.wav"))
  end
end
