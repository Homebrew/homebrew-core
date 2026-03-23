class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://www.apache.org/dyn/closer.lua?path=datafusion/datafusion-52.4.0/apache-datafusion-52.4.0.tar.gz"
  mirror "https://archive.apache.org/dist/datafusion/datafusion-52.4.0/apache-datafusion-52.4.0.tar.gz"
  sha256 "a71085a73744c53def7ac28c6dc8100fc15c8781b8e333857c55700469f0a77f"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19eae13c6321526c3b213a36cdd8765b426b0f7673d4622343255edce3ec2c86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd2c99ac2e7a9645e47666bf79ce4bc661fc5aa5c0f529cae8bda9f61c6f2b9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33338ac3ca0f448e68925e6f6ad0bfc9f75769a8226b0dd5612b76498adbdaec"
    sha256 cellar: :any_skip_relocation, sonoma:        "deca9dba636b499118ca94e599101d6b1144a32ea2fb9b27183d9adafa70927e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a81c4874c27b77ddc248ee27abb78b9c01ba3bb807a71e3df9651732f93136f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ddfc63e9a96b536fe7869d44ccedadb5f2f3f1a5c48f43f5354879785955780"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write <<~SQL
      select 1+2 as n;
    SQL
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
