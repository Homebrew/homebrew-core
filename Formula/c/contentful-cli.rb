class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.10.2.tgz"
  sha256 "3c8be28ebe11f803ca3821ebe2b89c883615c041ba07f70942b6cc8577b8cb7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5f7d9f893b2fa62e4fccbda7c6f8d6773a63c1bf0eec03a9fa39b136d1705a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5f7d9f893b2fa62e4fccbda7c6f8d6773a63c1bf0eec03a9fa39b136d1705a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5f7d9f893b2fa62e4fccbda7c6f8d6773a63c1bf0eec03a9fa39b136d1705a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5f7d9f893b2fa62e4fccbda7c6f8d6773a63c1bf0eec03a9fa39b136d1705a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5f7d9f893b2fa62e4fccbda7c6f8d6773a63c1bf0eec03a9fa39b136d1705a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b58f14eb0174b35f80446a29e2be2d0316bf5fd91d99b217f2024902b63d9da0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
