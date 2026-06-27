class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "96702a7d3994f36918212fab6cb28f49b207a5f1fce49e8c998f42a424c10f89"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71d3338753322ee15f4724e19fbe0e2731979c89cabb46eaeea28834d3bcca13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e36c38a6dec82d65738927b21c5ab826d9ebb48bfa1f8d65d32f8ef5a1fd1dcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5e901e40b154685fc3aa43435eab4af0f04b3c42a0ed14673dfb1cc8f7722d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "22e0b83b82d27e7b1890325f4884db2d7d8b0a080f01dfeda61db8760bdec598"
    sha256 cellar: :any,                 arm64_linux:   "698c6d24a77c679850c4637ea61e6a70b91523fa6fa28d7ded06f7059a52c54d"
    sha256 cellar: :any,                 x86_64_linux:  "411f00d2a500f138846950d6fa82cd81acd7b7eda914850ff122425f1e9bca7e"
  end

  depends_on "rust" => :build

  conflicts_with "mtools", because: "both install `mcat` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/core")

    generate_completions_from_executable(bin/"mcat", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcat --version")

    (testpath/"test.md").write <<~MD
      # Hello World

      This is a **test** of _mcat_!
    MD

    output = shell_output("#{bin}/mcat #{testpath}/test.md")
    assert_match "# Hello World\n\nThis is a **test** of _mcat_!", output
  end
end
