class Pdftilecut < Formula
  desc "Sub-divide a PDF page(s) into smaller pages so you can print them"
  homepage "https://github.com/oxplot/pdftilecut"
  url "https://github.com/oxplot/pdftilecut/archive/v0.4.tar.gz"
  sha256 "8a75a0d2e196d156bca4dc006f84c9b7730f20be8c0fc2c90521c538aa627188"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "e9cd816b6b435a80e0860b9a3d4e62aea35e85bbb6df82ba9308c4b8c10245d1" => :big_sur
    sha256 "a36f6efee23fc0af788bdef8017bcfee5b0fa25031541a499508f4942d743083" => :arm64_big_sur
    sha256 "015c4f2b9481772318dabbf7f8cb5aa0640e46781d7cd7ef5cfc9f33b91afb79" => :catalina
    sha256 "59229d726c29240bd14240e9011bfc1ec731ffcef8e52373c5a720649e6cacb7" => :mojave
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
