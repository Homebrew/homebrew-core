class Mkvparse < Formula
  desc "Utilities to convert between EBML formats (such as matroska) and XML"
  homepage "https://github.com/vi/mkvparse"
  url "https://github.com/vi/mkvparse/archive/v1.0.0.tar.gz"
  sha256 "b9816cb036be1e6c01f7b9dc24f9317be554779232a473ec2ac34462d75ca74a"

  def install
    bin.install "mkv2xml"
    bin.install "xml2mkv"
    lib.install "mkvparse.py"
  end

  test do
    system "#{bin}/mkv2xml", "<", "test.mkv", ">", "test.xml"
    system "#{bin}/xml2mkv", "<", "test.xml", ">", "test.mkv"
  end
end
