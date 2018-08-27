class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/1.3.4/BWFMetaEdit_CLI_1.3.4_GNU_FromSource.tar.bz2"
  version "1.3.4"
  sha256 "57e45ec18bfa70d903fad606a323e68a819c0147a6d507b7f0b5f4d59d6fc337"

  bottle do
    cellar :any_skip_relocation
    sha256 "89fce8fbe7eeeb79bc8f9ea19b8629a66bc27b70ceec44bab8d78c831ed6a470" => :mojave
    sha256 "fefc0077e1204f52b833ec9c41e91eeb02e293ea2b7e9a81920cc9c9b7cf486f" => :high_sierra
    sha256 "5b8dbbfc3ca812721adc6ddb4f649570575a366c8520013c1b363fcdaaab2a7a" => :sierra
    sha256 "6cf147efb68f7a4e672c3a7e5629548d71185e098260146a7d2aa01dd2f1a469" => :el_capitan
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
