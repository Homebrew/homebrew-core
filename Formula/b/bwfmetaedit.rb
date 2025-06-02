class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/25.04/BWFMetaEdit_CLI_25.04_GNU_FromSource.tar.xz"
  sha256 "4e7f4606bc83829a9ac1742c10d0e5d730da2189cfcb8cab9b739211e094ce75"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ada25a119a8c8c7e44971889d228b77bc2f09062eb5dcdc6671dbb8cd0ee5a8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1d559f8aa1a0134eb6be9263845ca2ce2e0e1b5be84d8eb99a3bb684a74b4be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b46ff3c597d15626a9b43b0e7ee92426e9cb4e9c68422f98d6ad7f8e8f35e071"
    sha256 cellar: :any_skip_relocation, sonoma:        "d39509378a55eb0278668436faaac2274a9d702488180300c8ed17880335f362"
    sha256 cellar: :any_skip_relocation, ventura:       "f7e1e0fe0fd5c8982325e0208d55b0cb2f68235d4ed4cf01c47ecb93b138dfad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8abba81e78de3d8dc5512552bec11d7d5fead6598266f7f8a4f9a3469343999b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66f8c9ff2de246093fd6829c4a80d56ad06e6d3e5ef5381949b50f1248fd36d7"
  end

  def install
    cd "Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    test_wav = test_fixtures("test.wav")
    ret_status = OS.mac? ? 1 : 0
    output = shell_output("#{bin}/bwfmetaedit --out-tech #{test_wav} 2>&1", ret_status)
    assert_match "FileName,FileSize,DateCreated,DateModified,Format,CodecID,Channels,SampleRate,BitRate", output
    assert_match "#{test_wav}: Is read only", output if OS.mac?
  end
end
