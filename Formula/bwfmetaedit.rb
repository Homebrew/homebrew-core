class Bwfmetaedit < Formula
  desc "Tool that supports embedding, validating, and exporting of metadata in Broadcast WAVE Format (BWF) files"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/1.3.3/BWFMetaEdit_CLI_1.3.3_GNU_FromSource.tar.bz2"
  version "1.3.3"
  sha256 "ceb4d45ed385b82c93381cb44bb9d15ccdaf4fd65f264a8cfa069cbf4f0712c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9856faf39690116683ebaa271d804fab3fc981f11043c52dd36b99af95f1b49" => :high_sierra
    sha256 "65f5716802ac4751a41d3890fff61d709a9c53ab4c4f4f4875a35f28b08818f9" => :sierra
    sha256 "861025e945a567a60d7409256d4108f121054d8c4335234a92b983e5bf195faf" => :el_capitan
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
