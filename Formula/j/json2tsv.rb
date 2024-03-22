class Json2tsv < Formula
  desc "JSON to TSV converter"
  homepage "https://codemadness.org/json2tsv.html"
  url "https://codemadness.org/releases/json2tsv/json2tsv-1.1.tar.gz"
  sha256 "eebe7e6286558af0aa0db7c552a4c1ff1e350eb662ec665155c2611990a9c34a"
  license "ISC"

  livecheck do
    url "https://codemadness.org/releases/json2tsv/"
    regex(/href=.*?json2tsv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa72517c329cedf0f5f2f552e21b6dcd72393e102d8d71cbe84120ca82f08720"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a2fe44b339acb840974ae83059c75e9dcd7e6b2ea0c1ff0c2a489c7dc698455"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8452946190ed92e8404f3d40675f8120c15d470f3b7e38ed7d2a4cd10d2096e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae51821f02f107a0b40da0345d0a4b6d31926e4cb568f1a48eabf5b577fdf5b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bd09d7e3a502b18bf78e6bf9967cb2326fbfa16f638cea8d145e194fb5a380e"
    sha256 cellar: :any_skip_relocation, ventura:        "ffb069dca6da384b6989354dd7d00567b4169360035dda3901a8a7442a4c12a4"
    sha256 cellar: :any_skip_relocation, monterey:       "e6c931d0a20605971fe6e9e2fa91050e7a84d9225709a1d55f38a4a756c72937"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f991360db7c5f9be2acb695f3efc6d9f5c67301cbb4cd50d630dc11dbc4073b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f31d004ff27bc78bfbb8880ce832cbbe128eeb2400cdfa2105e69e00dfc26101"
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
