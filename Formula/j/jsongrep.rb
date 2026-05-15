class Jsongrep < Formula
  desc "Query tool for JSON, YAML, TOML, and other structured formats"
  homepage "https://github.com/micahkepe/jsongrep"
  url "https://github.com/micahkepe/jsongrep/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "9ed0a0f7ca44652e7851ba7223bb69af56498311b1d5b2064f7bf532677c8a33"
  license "MIT"
  head "https://github.com/micahkepe/jsongrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c99626120c03c11d6975816987703f4ed6bcec13d9d2d0d1d084acec3d15c4c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f438dbd80f5932a8731835d0e6da1eb30e0b141c27b59c84b75922e25d9991a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2682a083792707f9985d714ca321e3c7aab54254e6b0e43714f6f61d1fb0680"
    sha256 cellar: :any_skip_relocation, sonoma:        "9861c77aa8e4474dce67405c48e2a2e707f7a0fa95a567a3d04dfe30f81c7bd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "943944a9e855d47810df639c4028e97b6dfe519a2d6d6b81555035d43ec842c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8d9744e9327d7c11fd437e20ca3142d8af778fad3ab775dc7ccca4ed8d93737"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"jg", "generate", "shell", shells: [:bash, :zsh, :fish, :pwsh])
    system bin/"jg", "generate", "man", "--output-dir", man1
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jg --version")

    assert_equal "2\n", pipe_output("#{bin}/jg -F bar", '{"foo":1, "bar":2}')
  end
end
