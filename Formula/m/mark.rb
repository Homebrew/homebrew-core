class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v17.4.0.tar.gz"
  sha256 "5499f7950c2ff5523d7b492abd73a24714502178cb6e94352371e7d8a119c909"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    manifest_sha256 "a91b99643e69147a9665d6269c29ba3347b30831e988506faedaec95d5e449d8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9a37a2bb9680b6d2aa58d0f94fc2018cd45582b14fb6da7c5c618db4777742a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c9a37a2bb9680b6d2aa58d0f94fc2018cd45582b14fb6da7c5c618db4777742a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9a37a2bb9680b6d2aa58d0f94fc2018cd45582b14fb6da7c5c618db4777742a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0edc651c32bbffa9246f5354458790ac399196ae44b40fa229df42bed5ee3619"
    sha256 cellar: :any,                 x86_64_linux:      "6fa9195a4fe637e247780cb6155ec844bce94f2e8eb47ca55765865a31765857"
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
