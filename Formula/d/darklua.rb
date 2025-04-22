class Darklua < Formula
  desc "Command-line tool that transforms Lua code"
  homepage "https://darklua.com/"
  url "https://github.com/seaofvoices/darklua/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "133baa4e584f7566dfe38bec3b1fcffe43e795cc28af0465ab792acf31fa2264"
  license "MIT"
  head "https://github.com/seaofvoices/darklua.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65353fe3b327985d26b88e45acc7d2448458850a15c70acd9e310dece10b5140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51e1aae12cddb661d59ac58804f67e610308b2fcdd4d8e1820b14c7d2fafb049"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bd5f668a31c24ca6fd4c317e4699531c323b64c5cd19e37eb8b3458d6d8df63"
    sha256 cellar: :any_skip_relocation, sonoma:        "96749c157b2ff99a438cddb5159ffec85660e16b00e48ffb63a80882ca6278ed"
    sha256 cellar: :any_skip_relocation, ventura:       "ac5f3cc4f6355b66cae12369ae5dd85e1ab095af27a23cdf8a047c330b0f7b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab9e34f90b146992bbc5b7e88f14536fdf9bebabecd9cfbb3e657a4ef0b23f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8354ab92f83f7c68125c741cf2857d3fd8706e16a8769b719b16103b9a8e24d0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/".darklua.json").write <<~JSON
      {
        rules: [
          'remove_spaces',
          'remove_comments',
          'compute_expression',
          'remove_unused_if_branch',
          'remove_unused_while',
          'filter_after_early_return',
          'remove_empty_do',
          'remove_unused_variable',
          'remove_method_definition',
          'convert_index_to_field',
          'remove_nil_declaration',
          'rename_variables',
          'remove_function_call_parens',
        ],
      }
    JSON

    (testpath/"test.lua").write <<~LUA
      -- paste code here to preview the darklua transform
      local foo = 1
      local redundant_variable = ""
      print(foo)

      for _, v in ipairs{1, 2, 3} do
        for _, b in ipairs{5, 6, 7} do
          print(v + b)
        end
      end
    LUA

    (testpath/"expected.lua").write <<~LUA

      local a=1

      print(a)

      for b,c in ipairs{1,2,3}do
      for d,e in ipairs{5,6,7}do
      print(c+e)
      end
      end
    LUA

    system bin/"darklua", "process", testpath/"test.lua", testpath/"output.lua"
    assert_path_exists testpath/"output.lua"
    # remove `\n` from `expected.lua` file
    assert_equal (testpath/"output.lua").read, (testpath/"expected.lua").read.chomp
  end
end
