class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.0.tgz"
  sha256 "5f87f0e8730524303fa855ed4bd9fb96092d594b2eb4a36cdf2e53ef18884ca3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b046d9c208da078c486c993edada2e31791e197f0deb937068ce6236316f394"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b046d9c208da078c486c993edada2e31791e197f0deb937068ce6236316f394"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b046d9c208da078c486c993edada2e31791e197f0deb937068ce6236316f394"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b046d9c208da078c486c993edada2e31791e197f0deb937068ce6236316f394"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b046d9c208da078c486c993edada2e31791e197f0deb937068ce6236316f394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d19f7173c69ba46a5a14cca740dcae494e53fc4bfb0ac009ced72dc375223ef"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
