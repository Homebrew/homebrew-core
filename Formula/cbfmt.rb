class Cbfmt < Formula
  desc "Tool to format codeblocks inside markdown and org documents"
  homepage "https://github.com/lukas-reineke/cbfmt"
  url "https://github.com/lukas-reineke/cbfmt/archive/refs/tags/v0.1.1-1.tar.gz"
  sha256 "8cb6b9d4602d9fa14e11bb31a09ec25b008e4a62401e6c31fe477b23fcaec144"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    testfile = testpath/"test.md"
    conffile = testpath/".cbfmt.toml"

    conffile.write <<-EOS
    [languages]
    lua = ["stylua -s -"]
    EOS

    testfile.write <<-EOS
    # test

    ```lua
    local test = {foo = {'bar', baz}}
    ```
    EOS
    system "cbfmt", "-w", testfile
  end
end
