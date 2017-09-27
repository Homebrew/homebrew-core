class Bwfmetaedit < Formula
  desc "A tool that supports embedding, validating, and exporting of metadata in Broadcast WAVE Format (BWF) files"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/1.3.2/BWFMetaEdit_CLI_1.3.2_GNU_FromSource.tar.bz2"
  version "1.3.2"
  sha256 "2109d625cc834e38bf05641d550fcb0fe8c095f3fdc0fa69283d26410e4a9f74"

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
