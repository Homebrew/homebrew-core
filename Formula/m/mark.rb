class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v17.0.0.tar.gz"
  sha256 "e7c81d252e3c49b2c5bc8040f5ea74992be9de78cafbf91fab1b3d6fa71fe2b0"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a2be92cc8e110cb3475b095f5080eee3bfe51c8a8fa9f344bb8233486410c139"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2be92cc8e110cb3475b095f5080eee3bfe51c8a8fa9f344bb8233486410c139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2be92cc8e110cb3475b095f5080eee3bfe51c8a8fa9f344bb8233486410c139"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f699031bf9651d532fa97a090b487efcb9849d9131c026fec4696ee9b3ee144"
    sha256 cellar: :any,                 x86_64_linux:      "198a1f053e0da2fbaae01ad3bf42cd17b5016c3bf66d41235351fc0e6676c909"
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
