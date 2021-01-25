class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/20.08/BWFMetaEdit_CLI_20.08_GNU_FromSource.tar.bz2"
  sha256 "273600425521d27aa3babd5d564e7c7a8c71bbf359e0bdebeac4761fc753149b"
  license "0BSD"

  bottle do
    cellar :any_skip_relocation
    sha256 "1dbda1bf33cccd0b42ce0833f84c7f0a6a03162adde2650ecbd55cde00a89a8f" => :big_sur
    sha256 "3e74719411cb950866e9eec2b40fb5404238b6036a4a401785eb4cd1db220a9e" => :arm64_big_sur
    sha256 "f8fc7ea2c57a3eaa0a247cbce5ae47839efc7ef098f3333d34f0d5628250fef2" => :catalina
    sha256 "8c0514552045937ff4ed9d27073ffcd9e4516b44fea073eddd11729ac8fe2c7e" => :mojave
    sha256 "bc8b768a4849b8c3740b18becc861fac1cde2e5294662dcd6e5c5697b91b15a2" => :high_sierra
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
