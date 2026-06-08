class Darklua < Formula
  desc "Command-line tool that transforms Lua code"
  homepage "https://darklua.com/"
  url "https://github.com/seaofvoices/darklua/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "3d2813da25c40cca8c65ac493261af233d90b7f8dc5bb592b34b8a97d527df27"
  license "MIT"
  head "https://github.com/seaofvoices/darklua.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d75b5dfc5bb01ba4126aa2a48b6bd6ddb94cf2c843a50a71e78078574bcbae81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d234e8f977edaa7473671c8f0da099805aef75cab38e872805730167700920d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "327e86457e5af32729ce01bb9065be098036aa94394971f4b220ea030f836cff"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f171eea57cb29510c7d46e50b0d6feabd5717fba8851981f756c6910944d44e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "995c9b8899b8654edc6e2d70b59239a9bbc017fafc0614249c756524bd4ace58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8c31316a1a51f22df6a25d57e81101e36672afc7c4c6e588dc345c16120ea68"
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
