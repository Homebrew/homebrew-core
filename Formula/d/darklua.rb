class Darklua < Formula
  desc "Command-line tool that transforms Lua code"
  homepage "https://darklua.com/"
  url "https://github.com/seaofvoices/darklua/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "91551c27342170b95fe46dcd07b07cedb09a8cbb569cd6560419e5a8937e2d97"
  license "MIT"
  head "https://github.com/seaofvoices/darklua.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82e7a3a6cdf74e65912535f33c1a9040ae06f25b8d0be43e5c137a6074b7d9b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7af58ed3c672813e379e59e82b270ad9a64a45c88e552452e2dfce959deec18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7239cc3f3c673d4614eb5d1068bad9e4c01bdc759d8b0f046408704910d94c2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6ead565a0cb0a87a66ba7507bd372904d75194ae726f6596406e2afa1757fcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "19659844a1bf8a898dc16a85162ba1a582eac73797eb42e07d81da18d29fb000"
    sha256 cellar: :any_skip_relocation, ventura:       "88568d1f77a4132f107da283e5b29cbf4ffcb44431b836a82e8fe49f35abbdc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39cad6f2f185952fa1f065b429c32724d9041546440d64a57a0dc653ed8d21bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d34eb733ab75310bfe44584013873675db550a780873f228ce23f2493cb4e154"
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
