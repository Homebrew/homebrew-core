class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.8.9.tgz"
  sha256 "33fe546c9454aae8fb396894c0ccd6f616d2cf923caf4a94278cecbe197a2cb3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "091de38bb0d1ab45e13cef927acc0f8bf1c60150b24512311ea75a97bbc8a514"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "091de38bb0d1ab45e13cef927acc0f8bf1c60150b24512311ea75a97bbc8a514"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "091de38bb0d1ab45e13cef927acc0f8bf1c60150b24512311ea75a97bbc8a514"
    sha256 cellar: :any_skip_relocation, sonoma:        "413bfc46f12709ca925c87984ff46b3d622fb4188a6a36f0a1dd2cab2bc3ce08"
    sha256 cellar: :any_skip_relocation, ventura:       "413bfc46f12709ca925c87984ff46b3d622fb4188a6a36f0a1dd2cab2bc3ce08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "091de38bb0d1ab45e13cef927acc0f8bf1c60150b24512311ea75a97bbc8a514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d25086e609f853608ed44c27c31f4757c87f125acaae44df80e5260ed5f247d"
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
