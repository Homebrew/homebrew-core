class Pdftilecut < Formula
  desc "Sub-divide a PDF page(s) into smaller pages so you can print them"
  homepage "https://github.com/oxplot/pdftilecut"
  url "https://github.com/oxplot/pdftilecut/archive/v0.4.tar.gz"
  sha256 "8a75a0d2e196d156bca4dc006f84c9b7730f20be8c0fc2c90521c538aa627188"
  license "BSD-3-Clause"

  depends_on "go" => :build
  depends_on "jpeg-turbo" => :build
  depends_on "qpdf" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    testpdf = test_fixtures("test.pdf")
    system "#{bin}/pdftilecut", "-tile-size", "A6", "-in", testpdf, "-out", "split.pdf"
    assert_predicate testpath/"split.pdf", :exist?, "Failed to create split.pdf"
  end
end
