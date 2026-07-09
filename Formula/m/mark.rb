class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.5.0.tar.gz"
  sha256 "6a06e64a0b821c0d86bef9d82fb4e36cc0a9875884e9e29e0245333ba961f3f7"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbc32fb821f95ce6fc58c2ad791b64f13795da58ce08a4c711a320c7f4cff6b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbc32fb821f95ce6fc58c2ad791b64f13795da58ce08a4c711a320c7f4cff6b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbc32fb821f95ce6fc58c2ad791b64f13795da58ce08a4c711a320c7f4cff6b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff3c8e0d5d7aa2e00bd58c0a2d79328cb6c5f3bff5a76fc2620a76f0415d3b1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5883d4f433cbc3c6df1204bf4f48d5046da894dfbf27166b576a13f8873a3d9c"
    sha256 cellar: :any,                 x86_64_linux:  "3632feb150b21e35549470d26179e9946ea020fd794a4e9d50b69a3af78f266b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end
