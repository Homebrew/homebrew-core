class Pdftilecut < Formula
  desc "Sub-divide a PDF page(s) into smaller pages so you can print them"
  homepage "https://github.com/oxplot/pdftilecut"
  url "https://github.com/oxplot/pdftilecut/archive/v0.6.tar.gz"
  sha256 "fd2383ee0d0acfa56cf6e80ac62881bd6dda4555adcd7f5a397339e7d3eca9ac"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2c5121b94c0d057a347e8770437d18bcce632226dad2cf826ac49119c2f5460c"
    sha256 cellar: :any,                 arm64_big_sur:  "4797087f671ff29728caee9c21e104c7385bb0e82a6489b82cc1bfc31bff70ca"
    sha256 cellar: :any,                 monterey:       "af3cd335415f42b10886cf83d0710012e1422f95f290e952006563178f8c2eb3"
    sha256 cellar: :any,                 big_sur:        "5f5296e419ec3a658b156b8a6510e1a16cd1c618dac87f500bef5dd30195e6ec"
    sha256 cellar: :any,                 catalina:       "f0fd1252843c4215929e234451cc1b26b68f46d8e63e75c1188c1c1e51f3c3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d634ed8e3910decf0afd32b9f3f0e71c7c8ec4aa2aec508cbcb7778433d9d998"
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
