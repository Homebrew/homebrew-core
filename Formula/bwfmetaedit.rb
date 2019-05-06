class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/1.3.7/BWFMetaEdit_CLI_1.3.7_GNU_FromSource.tar.bz2"
  version "1.3.7"
  sha256 "15bce139edfa03adb63235803b2817205b5abea3f69643afae3da71d3298ad2d"

  bottle do
    cellar :any_skip_relocation
    sha256 "e258954081e5d8c34c3421bb825274f7f2e75a3ba907a9daa742735c8779d4d6" => :mojave
    sha256 "d4b195aef2be90ae4b9e37145637d35131748ab92b2b48a65e2f5e0ec5652fc4" => :high_sierra
    sha256 "d3f0d70d2b6a54d2f9c2aa00ce4bf304df76419eb6c0acd09efb709ad8c85564" => :sierra
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
