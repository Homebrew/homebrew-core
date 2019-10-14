class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/1.3.8/BWFMetaEdit_CLI_1.3.8_GNU_FromSource.tar.bz2"
  version "1.3.8"
  sha256 "58bab975d5cd5860246acad7260b07404f9cb453fc2f4acdd35ab4f5cf1d0d5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "5108c6006d488ae6fb10aec64418c43c1168c633b29b58c8c9aada9d2ed32607" => :catalina
    sha256 "84b882f74d83bb3e15132b2b702f8264ac865f043136c5b69a11a07fa9ce13be" => :mojave
    sha256 "0201e1bf51774f427210f28d27235c45e472571f76d3c82f840dc5c41cf47dd5" => :high_sierra
    sha256 "0d6fa85b0695eac0516072c1c736a63e671c7621ab8f56c82b787bcf167c3081" => :sierra
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
