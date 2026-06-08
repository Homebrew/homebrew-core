class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v26.5.1.tar.gz"
  sha256 "745dd636fd17386277bea53154e25a46ea3a1bb1369153babd8e4bb439937413"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a03629acb322a06c6ba547ae85b67aaf1b26ea1d6e3199ed8929782880402e66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e2215806c5a4f452023da1e805f5c76519050d9b416d6998b2aa38540ef2d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a02545897e7d7f432a0dc89ef760b6403a9840b4d5fe7002384b7bef566affa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5feca1a435c71f507b7bd067eb4f9f06a24ff9bbc89e55f050759f5dd20f6789"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a5fee70470c9e8068eb351d89550f42e631617355abc9f852b733af6766f606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fbd5c2cbcd4a4c760cad8d307f5844becb3b70b60bc3f551bf004cc86e3a0df"
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
