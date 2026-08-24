class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/releases/download/v1.10.1/git-pages-cli-src.zip"
  sha256 "a4b23a4ef54111b160e9dc749d288ba96645282f78f355bbf28d2b48a1c6a664"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a060f9d46ac1a31830744c5f7f6d645473dbf98eb224d638a34453328ec39113"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a060f9d46ac1a31830744c5f7f6d645473dbf98eb224d638a34453328ec39113"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a060f9d46ac1a31830744c5f7f6d645473dbf98eb224d638a34453328ec39113"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1d8b280ee61b3ffba12eca3f7dc10cf8dd484614e8d1201b2518e3814cd9669"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b65d30ac2990144492140ae98f517484c19b1137890ff2d2dfd492f81ba8872"
    sha256 cellar: :any,                 x86_64_linux:  "a87aa40c98fa6187d30474e631312cfaed35125dd4bf3c3615ce0a780ec555ad"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.versionOverride=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-pages-cli --version")

    output = shell_output("#{bin}/git-pages-cli https://example.org --challenge 2>&1")
    assert_match "_git-pages-challenge.example.org", output
  end
end
