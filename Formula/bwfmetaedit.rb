class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/1.3.6/BWFMetaEdit_CLI_1.3.6_GNU_FromSource.tar.bz2"
  version "1.3.6"
  sha256 "1223de41f55fd7c33c9bb398a3af33c0f0bd0c1c9ee1add17175f15abd6d95d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "95e67d6b1350f285fe7b6f08a5c6608fac81fbcc4d7f764a6dcaa04c3e01e956" => :mojave
    sha256 "595ee66280c74d459e1db88d1b8afbace3a9ef8947e47a60f9f412eeceb29265" => :high_sierra
    sha256 "2c76ff728a6ad6f372d5a55df1c22af9c5f52f90694a1bd6775d1fc466ecbead" => :sierra
    sha256 "f6428c53fdf2b807b63584db27285984e479c1023d6cb8bf441bad9ac09766b3" => :el_capitan
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
