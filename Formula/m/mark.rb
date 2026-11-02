class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.25.0.tar.gz"
  sha256 "7ff930895198328d84368a4e9b3b2bbec976660058cdab04104f593c22ae0cfd"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9eb144beadf9d09cf323956de06b9ebb59999f1f1301f124b23b1138f5bae7c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9eb144beadf9d09cf323956de06b9ebb59999f1f1301f124b23b1138f5bae7c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9eb144beadf9d09cf323956de06b9ebb59999f1f1301f124b23b1138f5bae7c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "18ed90ea1bc8c06ff468d173ee9171ed6ee3d0f918dee84935ab20d2c4067249"
    sha256 cellar: :any,                 x86_64_linux:      "6065b2106b3df0cfcc988d82c68694b56e370ca80e1ce98058af0455cecdd0bb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    touch testpath/"mark.toml"
    output = shell_output("#{bin}/mark --config mark.toml publish 2>&1", 1)
    assert_match "confluence base URL should be specified", output
  end
end
