class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/1.3.4/BWFMetaEdit_CLI_1.3.4_GNU_FromSource.tar.bz2"
  version "1.3.4"
  sha256 "57e45ec18bfa70d903fad606a323e68a819c0147a6d507b7f0b5f4d59d6fc337"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f8d7dff09666995600734b89ff826cab0a95029b89682600bedc84e47a03adb" => :mojave
    sha256 "85ea1c310484ad3377240e91fccb9945f43f4aee701d51b14e61eb23a32a9bb1" => :high_sierra
    sha256 "79245545f860b2e00d41413bcf6c8f8bb2c6d21e9dc4902e2f69893ee182abee" => :sierra
    sha256 "0c61f8118a0a6ae3eda3c4504ea546504e437b07aed61c51225f75e4a2e700d6" => :el_capitan
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
