class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.11.2.tar.gz"
  sha256 "3016b50a9c1c88f61dc4f5b23dcba8658bd4a2e3d758bd90e9ba7c1868a53b60"

  bottle do
    cellar :any_skip_relocation
    sha256 "19802aef451dcf4c99a3bcf063ee2ffe3ddec9761d3a9e475858a08b16b7d64a" => :mojave
    sha256 "bc567345c115c98de7dbd1486d06a18a747224dc9af7578654efe6b3d4d03064" => :high_sierra
    sha256 "9893eb4e56253de4801a59bf1a30d15f1c6b4b7095f26deea08a986b1b170c36" => :sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "csvq"
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
