class Json2tsv < Formula
  desc "JSON to TSV converter"
  homepage "https://codemadness.org/json2tsv.html"
  url "https://codemadness.org/releases/json2tsv/json2tsv-1.0.tar.gz"
  sha256 "04e6a60d6b33603a8a19d28e94038b63b17d49c65a0495cd761cf7f22616de9b"
  license "ISC"

  livecheck do
    url "https://codemadness.org/releases/json2tsv/"
    regex(/href=.*?json2tsv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5319eab63adb0be095af2d96b736a9a3693240162aac9e4609ba5c27a2ecfd10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d04512803537d4cde3bf6e23a668c9bc5dade0a758ffa1526f223d1171bb76b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf9ea5403bd945f5296fcc8be5f93c38d89219bc6d56b4591d3f9c5d5f97528f"
    sha256 cellar: :any_skip_relocation, ventura:        "12835a2e6edf3b3b518c1eb713ca1b6823d86256ff516a652d5eb01e2097b12b"
    sha256 cellar: :any_skip_relocation, monterey:       "b8a830c90ded1876173e553fd7763ab9e81497e19742206b0d4d8beee515c08a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9d0d7572688db4edd9fb3832db512eb90ba86aff5fad7983367725983dba5e0"
    sha256 cellar: :any_skip_relocation, catalina:       "bd15b4901bf48b55d3d627c2626794d92812513e2d0b07235091c6e98478b82a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d11d28955ef25626830bbaa58ead3d5af7d0fb11f9702f0293180df3244b48f"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANPREFIX=#{man}"
  end

  test do
    input = "{\"foo\": \"bar\", \"baz\": [12, 34]}"
    expected_output = <<~EOS
      \to\t
      .foo\ts\tbar
      .baz\ta\t
      .baz[]\tn\t12
      .baz[]\tn\t34
    EOS

    assert_equal expected_output, pipe_output(bin/"json2tsv", input)
  end
end
