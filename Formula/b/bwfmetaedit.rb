class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/25.03/BWFMetaEdit_CLI_25.03_GNU_FromSource.tar.xz"
  sha256 "c48b6de1037951b44051c4217038f2b6c6a169fa9fd86aaea78dc22ac11cb9f4"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce0354cf96e37536f7c1c73142e7da7bcc5271a9cf24a69aa46f9a6b0d7c15b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9e3c97b9d2e869fda29305f101d923f1bc1f8611d4ba9f32895631086d4c9f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea1bda591966ce23cfad2827f52190b74cd3f1c3beb9e5430848d3bfa1a14eee"
    sha256 cellar: :any_skip_relocation, sonoma:        "a92e5daf4cd9bb128c343c120397eff72ddbe10636a610b3ced1bf91a1af2eb7"
    sha256 cellar: :any_skip_relocation, ventura:       "52028cdff6de53c1a891d9125423696eb0c65de65d8c0627224ae6671a6431f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb4c95064de0633b9c894447dce1f8ae030d058daaeeff21e9fb9ce8443bbd3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28dea660744b206b0bb01ceeb9ad5778d1fb25b0684b83bd6f34d9c2c4624646"
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
