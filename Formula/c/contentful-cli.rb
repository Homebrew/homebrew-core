class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.12.tgz"
  sha256 "0d08e949d2b7b895609ca406d6ae04ec83f4af35b102c1e8e3828ac2fdcfd6f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f6713ade4e9d77fc8536c92534a1350e231e4a42504948c35e248c2b90cbef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f6713ade4e9d77fc8536c92534a1350e231e4a42504948c35e248c2b90cbef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f6713ade4e9d77fc8536c92534a1350e231e4a42504948c35e248c2b90cbef8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f6713ade4e9d77fc8536c92534a1350e231e4a42504948c35e248c2b90cbef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f6713ade4e9d77fc8536c92534a1350e231e4a42504948c35e248c2b90cbef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa6d137c6cce967a99028e73aa98423adc23d07eb998abd2225e7f425a206f05"
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
