class Pdftilecut < Formula
  desc "Sub-divide a PDF page(s) into smaller pages so you can print them"
  homepage "https://github.com/oxplot/pdftilecut"
  url "https://github.com/oxplot/pdftilecut/archive/v0.5.tar.gz"
  sha256 "48a34df2ab7a9fbf2f7dbec328fae9cd15fff8a77fe938675a9e2ee336357b58"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cd783946f14694c88350aca877863aec712b788f220a8fe02a6e3e79d50f54d6"
    sha256 cellar: :any,                 arm64_big_sur:  "11d7a2b31e405708a309b9f0faf98e508ca920e1ad03b061f088652ced8099e6"
    sha256 cellar: :any,                 monterey:       "7166769343d909da78938cb1ee6ab1b106a3b56b8a51d154e93305b4cf644941"
    sha256 cellar: :any,                 big_sur:        "5cc898901cadbd6b08d17bb17ada4e636d00b8c3d4139343ccc26e8e701e4c81"
    sha256 cellar: :any,                 catalina:       "173f96dddd480ad7c18440dcc55fe1d23930b71b9ae38723e426214a13e03f15"
    sha256 cellar: :any,                 mojave:         "6da1ac7ea176188c87da04b27539d6a55e0a03736daf42959d577cca6a1c4014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "664c904c42e4832bee89e532931f1005f2a79eb0da02c8702d9d880f25cf5e0f"
  end

  depends_on "go" => :build
  depends_on "jpeg-turbo"
  depends_on "qpdf"

  def install
    system "go", "build", *std_go_args
  end

  test do
    testpdf = test_fixtures("test.pdf")
    system "#{bin}/pdftilecut", "-tile-size", "A6", "-in", testpdf, "-out", "split.pdf"
    assert_predicate testpath/"split.pdf", :exist?, "Failed to create split.pdf"
  end
end
