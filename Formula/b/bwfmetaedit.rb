class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/26.01/BWFMetaEdit_CLI_26.01_GNU_FromSource.tar.xz"
  sha256 "bd04770fe8a30541151b65bdcd25252705f390297d992ac461c9dc3c885de2b4"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "518fbf320e175c0ee0334e2237c30f9b6d58306d242c544c0be03ce470c46763"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ce116495823ddb61a7e0114f4e1271798af02a15cb040d5f7772572568a00bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d42c59d32633a32bfa3fe907916c78a4295bd1d1cd7f0e65edce539155de67d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b517115003660a83189a6aea3b142b4caf6ca00110b1a6db0d24c4cb9d7a86a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef6f068bbbd8191e98da8589ea5c5d9c82209a72629e2e8160e5a6d47c30e93f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "664fc4e93a220a62f5bc59b2fb928296eab3532d739434826f4920288d090ce2"
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
