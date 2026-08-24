class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.12.1.tar.gz"
  sha256 "347cb9b3d967a4c72d1965ae9bd57947d0c7bd1618b1455a2a1483c359ce638d"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ffde6929b407374f11ac2e2394e00641e7b0c8acedc6f998e3ad5f67bb24233"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ffde6929b407374f11ac2e2394e00641e7b0c8acedc6f998e3ad5f67bb24233"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ffde6929b407374f11ac2e2394e00641e7b0c8acedc6f998e3ad5f67bb24233"
    sha256 cellar: :any_skip_relocation, sonoma:        "543b424a8fae76e8b74b760979ddbe9f9309a5472f8e0fd5dec45bb3a1d07504"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0b896201f01a47590129c155c36bec6943e1ad65281e6503019fc4002d9ec24"
    sha256 cellar: :any,                 x86_64_linux:  "6cbef8c724b2e7e1cde795f7309bb8cd843e90dbfba2dafa69fb835e8e421594"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    touch testpath/"mark.toml"
    output = shell_output("#{bin}/mark --config mark.toml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end
