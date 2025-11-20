class Pdftilecut < Formula
  desc "Sub-divide a PDF page(s) into smaller pages so you can print them"
  homepage "https://github.com/oxplot/pdftilecut"
  url "https://github.com/oxplot/pdftilecut/archive/refs/tags/v0.6.tar.gz"
  sha256 "fd2383ee0d0acfa56cf6e80ac62881bd6dda4555adcd7f5a397339e7d3eca9ac"
  license "BSD-3-Clause"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "90ee505ab0b2f3afc41e42a5ef8e5e3b02474868b9787fc73cb16d5ab66d909c"
    sha256 cellar: :any,                 arm64_sequoia: "a0233594179a8bdeb42d430dfe1384c716fff5d1062b8e00be0e0a3012778730"
    sha256 cellar: :any,                 arm64_sonoma:  "11b292ad9ba8f2e3ff99e3df455bf4558e854f95fd49c58dce4e5d3c1ac2f81f"
    sha256 cellar: :any,                 arm64_ventura: "954e44ab18431e84903ee37a9e08730458c0fc2ff3be83bb71bf54ad8aa5184f"
    sha256 cellar: :any,                 sonoma:        "02a045c5f5f1ea061b661c5f34fc9f557fa12a8a2ac47ba9ca5c240c0fe60433"
    sha256 cellar: :any,                 ventura:       "c76c17100539c6ba2aee77fd1cfad42a9464d15fd2e41edc51419308a85a1f41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd6a82f54be78a6a4a939ff44e7364993048d76f20c9063764b61ab7b21d5473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad6f8074acd3375047c5419afcd65722aae5949982d6611e95becfa6ee0cfc37"
  end

  depends_on "go" => :build
  depends_on "jpeg-turbo"
  depends_on "qpdf"

  def install
    system "go", "build", *std_go_args
  end

  test do
    testpdf = test_fixtures("test.pdf")
    system bin/"pdftilecut", "-tile-size", "A6", "-in", testpdf, "-out", "split.pdf"
    assert_path_exists testpath/"split.pdf", "Failed to create split.pdf"
  end
end
