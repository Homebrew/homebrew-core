class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/24.01/BWFMetaEdit_CLI_24.01_GNU_FromSource.tar.bz2"
  sha256 "3f5e4b6749eb2b047b431294adc052eb0dd4ffa1d62c94a2062ef9633912ce66"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "361c7979b629a9da067f7ac531607d483dfb8e4f00cf34ce44159916f1cfc1ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d77ec842af5a3137dc1de17841a1a295fae336d6341f2a0914e88fb140837ef9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1959f904aa560dc810714db55f3c705ef24b7aac8e70a7024c580bd3c3a0a0d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f8146cfe9434b4abd6c9f53069d59fbea9acefc2c8defec00697618113fd44d"
    sha256 cellar: :any_skip_relocation, ventura:        "57f98bb40a42836096395274fe9155650cede1e94b14955ae7a790bb1b1a4256"
    sha256 cellar: :any_skip_relocation, monterey:       "779f1cb81a073bed7267d5cd5a91e529560c8005ac549dbdd5e8f35d64793803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc01f81dba11a5658a1ecc0679199921bf8ae3f5d3bda8b21e5784db6b985cc"
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
