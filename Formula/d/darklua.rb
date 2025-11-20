class Darklua < Formula
  desc "Command-line tool that transforms Lua code"
  homepage "https://darklua.com/"
  url "https://github.com/seaofvoices/darklua/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "6afa725dfbc89686359072a69c10ec2d4f319612db73f80fa4e83f0fda514289"
  license "MIT"
  head "https://github.com/seaofvoices/darklua.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d951ca61ebe373fe7e69d59cfe711edb1d708a9243ebfb7893579fb47c8ab210"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "460be7c614fb4638e270e891c6151a5ff52e0921138aa7959f41697d49dba980"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a71c633f36b175216c553ca8f6b6553f88429ed21c2a9c04ff10b74aa0b4a45f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2331fba9c74ea75c2a663f16683050ed7e00991f5777e23d6d150152dc5244ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4166b93ee7a64962bc924d89d34a2406e641fec4c185c3e7e6e3645bf0e5543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "947d96bdf59b50c7def06b4cca785e2553edde09bcb88e4e738048ed16faf973"
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
