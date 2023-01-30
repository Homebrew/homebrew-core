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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26bf69734e9348d184335ed12abcb450e8db91204246c2f32e29bcbce78738e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a61e6e7e84b506e7cb0e064d4087e0b59fa45151e1ae05c4c4515496c517acb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b76e0ad38844db9668fc5885858f2bee3c8180632e3b5556fd6c95ebc4044e6b"
    sha256 cellar: :any_skip_relocation, ventura:        "d7b845048635a5769c35482604891f5c4e020ec3d0b21e4a4b636a2eaf89423d"
    sha256 cellar: :any_skip_relocation, monterey:       "a6b24e90079bebe187b3284b1bc1c439aa951a2d1025388eb2a42ca44ca9260c"
    sha256 cellar: :any_skip_relocation, big_sur:        "812c4e0bdfd0df0e42a73c2c41fce5d12a1d77de6c0ec7cc7025c4ccec657ede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d708cbe1838ebddf13d40da8721a85e79e271ce9e30b40d4441237b99dd49ec"
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
