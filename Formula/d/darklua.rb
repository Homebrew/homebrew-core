class Darklua < Formula
  desc "Command-line tool that transforms Lua code"
  homepage "https://darklua.com/"
  url "https://github.com/seaofvoices/darklua/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "6f2ce6d6f29aa256ca1ec47e33a25937a6964b1ada1083d427ebcc6a7d4ab43f"
  license "MIT"
  head "https://github.com/seaofvoices/darklua.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "907bcc4d12da0c96577cfed0a4ddcaa11976458542911e43231ec5404a074b7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "468089a06881e0183d019ae9b652c01b0f1ee8f8f6af8cf00a42f0735db70066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3180d2f2e21e7d37ce66581ae90a1cb8477889221455a0f30296f8fd7856c74e"
    sha256 cellar: :any_skip_relocation, sonoma:        "42075c3d2cea8d47433efe6352d7a5ccac9774b2d4140671203c0bd496cf47b8"
    sha256 cellar: :any,                 arm64_linux:   "8ad8ed90fb4521262b66dab8a26667db6114fe5784382023cf7169437917db1b"
    sha256 cellar: :any,                 x86_64_linux:  "94c09f96d8cc06821efe035d6e634840d9d6b3a662e31dfa76413d10c9cdd50c"
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
