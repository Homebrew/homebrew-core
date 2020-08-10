class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/20.08/BWFMetaEdit_CLI_20.08_GNU_FromSource.tar.bz2"
  sha256 "273600425521d27aa3babd5d564e7c7a8c71bbf359e0bdebeac4761fc753149b"
  license "0BSD"

  bottle do
    cellar :any_skip_relocation
    sha256 "72cdfdf26527d3a82cac945c81a9a53097dd4831f3a315fdbd1dc67e0f1a01d0" => :catalina
    sha256 "3afb53dc8f46493cc50dbce9d6369b84385110b908a847d2ab84eca9c06ff8cb" => :mojave
    sha256 "332b5ad0e217e6433f51d25135f98036120f6444820dcece627228c1fdfe881c" => :high_sierra
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
