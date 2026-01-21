class Darklua < Formula
  desc "Command-line tool that transforms Lua code"
  homepage "https://darklua.com/"
  url "https://github.com/seaofvoices/darklua/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "cbcfcf0640a25fb2c69972a8630107d37a7521cf9b2d0244ed7aaf4ecd2447a2"
  license "MIT"
  head "https://github.com/seaofvoices/darklua.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ab2373184726e0667c9e8a19bdfc755f2a6a7a6c98e56011bb2f0331c934391"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee8ced9dc04ac67490e852ca2a0267e12aa4c9be84c27aa77afd154e7ed8e425"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04c1bdf995f4aa732f2439b34c22e080ec6b564a9a80af8fe27b80f12e7950d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0446fb2984475574d12d441f4149148b3a57916859aa07a570b3dd0f6dca51f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da6b352e0474188b8498b80ce1b9b980439fff15ce8966f9a36812620e682d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e77298fc123cd47d680c613498f3a66ca06a896df93d25cdd54a07480f9d3825"
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
