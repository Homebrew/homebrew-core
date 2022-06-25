class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.17.4.tar.gz"
  sha256 "923e2735f379ce6970d8f19e5c0e71096ed5014dfc6943f4fb4486a9cc04ecf4"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b401e696ac374233cc8a391ddbdb4f33c9d27843b5a3cd73db546ae9344f6d68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b5daf09fcb7c124a01b29d57311dbead506a7b19ef60700618a884013cbc522"
    sha256 cellar: :any_skip_relocation, monterey:       "24831b4d4e5aa8d7d19d0dd062875892617cf36c4f92f171463a1463297fe81b"
    sha256 cellar: :any_skip_relocation, big_sur:        "69033431245734f4661443b5323381bd494f00ddf21760e2a82c07110dca1092"
    sha256 cellar: :any_skip_relocation, catalina:       "95d544c806c6e370bbe48f3112572762af7db130599b3621ee04519dfabaddec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0f6137ed7313bd23a70f60df8a1bcfb85480618cd37e71906e07a04fc3f7ba4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/csvq", "--version"

    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    expected = <<~EOS
      a,b
      1,2
    EOS
    result = shell_output("#{bin}/csvq --format csv 'SELECT a, b FROM `test.csv`'")
    assert_equal expected, result
  end
end
