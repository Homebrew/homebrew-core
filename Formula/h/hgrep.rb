class Hgrep < Formula
  desc "Grep with human-friendly search results"
  homepage "https://github.com/rhysd/hgrep"
  url "https://github.com/rhysd/hgrep/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "c8246d7ff9a8b7cb11f18892f68d16fbd8b7237c37e9bc34c95aaab43be48222"
  license "MIT"
  head "https://github.com/rhysd/hgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "088a0d7f835018567e208e121a2b412cc78aef8d2c4fd503a782a9d7a711ddc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69d123d00ea2f0b6a742894f6b5a8efb12ad5f30e00fa9f7b7ced4b9d405afa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61bad2fc8c424556dfb8ab4139d4c6c357886b6a704e9363d472b9ca3704dcbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e72adf5c47c3815553b9b0313cfdbfc0b4607ec4f989de915acac28c1834c89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06e7984aa5cad71a77c73ac753bd82cb5904b23fcfdbda7cb464430488e9af78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c7cdca84a0d997620598c28f648b9306c0a651b63b29d0323d4af5525ef16e3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hgrep", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hgrep --version")
    (testpath/"test").write("Hello, world!")
    system bin/"hgrep", "Hello"
  end
end
