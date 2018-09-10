class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/1.3.6/BWFMetaEdit_CLI_1.3.6_GNU_FromSource.tar.bz2"
  version "1.3.6"
  sha256 "1223de41f55fd7c33c9bb398a3af33c0f0bd0c1c9ee1add17175f15abd6d95d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "59c1e6289726ea39e173afd6418d26e9b46feeee03d01b6caaf5b6ffa0e69711" => :mojave
    sha256 "8d4491da134ad7946b9f4dafb93762e8cc3ef5ae7472de25ddcdda49bc3a1264" => :high_sierra
    sha256 "c3ac3fded8f13d7bf277a4c76b586d1fc6fc6c90b14842f36c586b36a3241b97" => :sierra
    sha256 "e0162b43a0806a785da4f4838ed5fcf0d60bd809b3fcc915c58589c9e6938798" => :el_capitan
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
