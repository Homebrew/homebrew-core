class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/24.01/BWFMetaEdit_CLI_24.01_GNU_FromSource.tar.bz2"
  sha256 "6c1f23889c85cab57aec2177317686367f0b0fcac993d28613f0bc6b22ba7f8c"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1566fcd8571f9eb847d3aa73b715361ab3be67a70b8ff2cac18f8722bb7bfb08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b29bd0f00ea52b62c2308e80f8bb442287d138113e6f2c8be2d47f50ba396c05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "519b0c17b7ea47d3310b7862b08ddfc4126eabf2d6a054039345cb65c2c86cc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "437408e0caeeaee30249a53e6ec337aa96bd4e7f014ec243afce4b3dc114c62d"
    sha256 cellar: :any_skip_relocation, ventura:        "c75dba18a6f8ad685fc105f94949e69c13c66ba5fb718745d6cdbd10a91fb043"
    sha256 cellar: :any_skip_relocation, monterey:       "ead780bb19dccf95345c52818037c16b0aa72fdd3d09fe966022c05cc4111486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "805a5c0e876b7cbee886597d77bf23a878915e106903180be6e37ba57416ab59"
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
