class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v26.1.1.tar.gz"
  sha256 "8c4c8af3e7f029b3963c1a41066fefaf31934c377d7bfb9daa81823517bb2e5f"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd5a68edbfea9e5ce0b4746b39c255978e4593542af9ab1d36bf8703ebed5602"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d44f2d67dadb32c29ac4832f2987d4758683821d324a639463bb2dabaf90800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0de2ce3cbe96a69d59d153ce3aac96b9efdc39cc1d9729bda589f410c4904cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "560633cb631e33315679a9230871a10135732b29576dc6363a834219d93e1ea9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "831ac75362d44ab8896f50f687ed9fca976a8c4f8c20d3413b80c1124153a36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2bffbe899b0c57316d84129f290a15fdb5593bc4b07d393d2864b8b14a5ac25"
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
