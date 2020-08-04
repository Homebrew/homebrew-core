class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/20.05/BWFMetaEdit_CLI_20.05_GNU_FromSource.tar.bz2"
  sha256 "3eab6955aad9df5c6ab193492ea7d90709eb9214e9581cd190188a0933e4f1fe"
  license :public_domain

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
