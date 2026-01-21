class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/25.04.1/BWFMetaEdit_CLI_25.04.1_GNU_FromSource.tar.xz"
  sha256 "9a8830c32e561b2bac0467413de5d75d3853b7afdbbc8b830cbe6b4eb075c1b5"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a576b9c54a6a0326ec348b601c0e658ce35e4c0d7d0781553d12d4ada6d1e8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d85b31fff2a4763c289f8152dcceb7e37ed12a9049c9c373e569dab3ccf787cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71765c38e82677ee12feadb978f5ef2cbeebdb02804341066ddc22dd06ca7238"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b18ba9f78bd452fb382de7852b066c28bc34049aa5a7158478dadfa6fae469f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0093ca11665ba05239cd1f85a9d6e1a1cf41ea0e0bc8c685de456c53d713939"
    sha256 cellar: :any_skip_relocation, ventura:       "efe96dc3b69b7704fd8cd1f0722913c27fac7c6a92c2fecd4c5c8c9a3d243006"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "738627e85ae70d8e6fdd20fe07959c2406270b19bab59c2cec493830245941ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ab0427146edc6638cd7bdc09f485ca1108e3fd89230407db72c1d27005bacf8"
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
