class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/23.01/BWFMetaEdit_CLI_23.01_GNU_FromSource.tar.bz2"
  sha256 "2cbaa9240e48a6105c8dfd27cc0ac252b41311510db785bc6382c1328dbf0c51"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df2bee4c744fe05c0c1e6310d9eb7873203a9dd1d65726558c65007b22c69fc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0b97fc28c5918ea3d8eb7faf188b5d843a5d2cfd39068a2658d4f111276fc8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdc4cc6e1faa7e8c7926e12ca509d35ceacf6b1e4ebae634fdb25308ce8241b3"
    sha256 cellar: :any_skip_relocation, ventura:        "72b091fa0bf72711c64bc22a6c68ab6bb6a4e7284fac2e24649dd0db95f71e72"
    sha256 cellar: :any_skip_relocation, monterey:       "5c3722c22fe93cccd2387b36222cf5c0c8f0af45c13eacc63e7dcd6c5e08d80d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1af3555fbe262d5ade4989031c434a9557173acc47f38d52d33b20e921941ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae10b4e571fa99d15876e829cbf280744499fb694c1df2441210c00ac11550a4"
  end

  def install
    cd "Project/GNU/CLI" do
      system "./configure",  "--disable-debug", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/bwfmetaedit --out-tech", test_fixtures("test.wav"))
  end
end
