class Par < Formula
  desc "Paragraph reflow for email"
  homepage "http://www.nicemice.net/par/"
  url "http://www.nicemice.net/par/Par-1.53.0.tar.gz"
  sha256 "c809c620eb82b589553ac54b9898c8da55196d262339d13c046f2be44ac47804"

  bottle do
    cellar :any_skip_relocation
    sha256 "457e5ff8ba94268a745fc954f84cbbaab7ac7d3a239ca602107a85a2e5d146a8" => :catalina
    sha256 "ef5da7a3e359ba4c72ad4f11c2f1fb18adea19c6c51409d0fc7400ec60ef2422" => :mojave
    sha256 "344dd1109a03e8c6017c2ca26a17c9f07c700c743b89b42786efce956bac70e1" => :high_sierra
  end

  conflicts_with "rancid", because: "both install `par` binaries"

  def install
    system "make", "-f", "protoMakefile"
    bin.install "par"
    man1.install gzip("par.1")
  end

  test do
    expected = "homebrew\nhomebrew\n"
    assert_equal expected, pipe_output("#{bin}/par 10gqr", "homebrew homebrew")
  end
end
