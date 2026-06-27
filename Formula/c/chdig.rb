class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v26.6.1.tar.gz"
  sha256 "e694f99e21e800268eea88f0b38f5fea864205860c17d158cc776dd3fcc32e4a"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d73bfdcd9970af919bfed896dd5267f4b2db48c5175d7f5ad84e992cbfe394ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbee834244bbe3b232ebaed75ec23022587879a5aa4bec43b6cd15ab1c1552f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98d94ba80ebec9d7e9abcb95f4c3812ee15b310f2641c3d61cc48ab4517ccb84"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3a83cf479d19012e4cd7f56a4b1dbc8516b7555c5803357267321ebce7bcae5"
    sha256 cellar: :any,                 arm64_linux:   "6173343e4142584c744bf38d5b9d8217e4fd9da3de55a6b454d69fa7cedb55d6"
    sha256 cellar: :any,                 x86_64_linux:  "06167154abe7ad8090da0b7a1d9fa7cbb5308034862093f304e64429ddf049b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end
