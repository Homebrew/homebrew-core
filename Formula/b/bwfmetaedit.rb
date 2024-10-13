class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/24.05/BWFMetaEdit_CLI_24.05_GNU_FromSource.tar.bz2"
  sha256 "49b5859e5d86c226e2b0bef5d3f9ef0067112ab676fa8a819be1b2fff89cffac"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0ec66bc1c55cc155e8d48c5a73f09d4c3e597ee9845bbd698ed1df626d7a370a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8923efd65e8d09b5d297648b94665b530fdee5d0091948f40214d792cb45c14c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35a846103984bc8d126e54a61690d01d224df191a33d4f2e602b627ab121e023"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3bbf06b72fe36ee260fa864b59215056da9302671ceb33f0f9c0e10f0d66f2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "26a56475834d162048d1e8cc1560df52c2a8c5b1488c64fa6c47322784d3287a"
    sha256 cellar: :any_skip_relocation, ventura:        "041c8f958fc607d9c480a93914337f66a3cac938279af2db7a6f439916e2c184"
    sha256 cellar: :any_skip_relocation, monterey:       "11086679000fdea51d861409c3fc44939284ddbf06d8f7e9db76449ed6293896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe3e85bb878b941e59a20d830bc09489f586eda0b7e9b09f719fd8984ab57f60"
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
    assert_match "FileName,FileSize,Format,CodecID,Channels,SampleRate,BitRate", output
    assert_match "#{test_wav}: Is read only", output if OS.mac?
  end
end
