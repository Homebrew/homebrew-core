class Bwfmetaedit < Formula
  desc "Tool that supports embedding, validating, and exporting of metadata in Broadcast WAVE Format (BWF) files"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/1.3.3/BWFMetaEdit_CLI_1.3.3_GNU_FromSource.tar.bz2"
  version "1.3.3"
  sha256 "ceb4d45ed385b82c93381cb44bb9d15ccdaf4fd65f264a8cfa069cbf4f0712c1"

  bottle do
    cellar :any_skip_relocation
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
