class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/24.10/BWFMetaEdit_CLI_24.10_GNU_FromSource.tar.bz2"
  sha256 "fa32a60a4bc2be654c35a55b42a57fe861bf7f1e52e83f4504a20b329a751416"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0ecd2f1740f7191778621bf35d68b97ba486db31ebc1f9ed5a9c150cf27200f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1546efb0639f856d5410a8531a27d4ced04de940e388808e5abee8d22a332873"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d303028529f94d21d6610d6e3741da52c49878c3e7b3a1d4fe09597c926dd79d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0889b2b8937bcc182bd2f98649114f51dca93f9fe8fcf1540ccc030bbc3bc424"
    sha256 cellar: :any_skip_relocation, ventura:       "20974bd0e43a7d6068358eea11f0b330807f9646265af45df3e0d541581a5670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9523b923b075bb47cd1b8eb10d59613392742b2eeacda1edf142ea84cd6b9b4d"
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
