class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.19.tgz"
  sha256 "e5314f2504c37e7e8079ab70d4d081c14eff4815e79fb20a8364cf815afe17e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fff238f753c0a7da91926a267ee40e59dac82124ab0af55179e1148d2d14f7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fff238f753c0a7da91926a267ee40e59dac82124ab0af55179e1148d2d14f7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fff238f753c0a7da91926a267ee40e59dac82124ab0af55179e1148d2d14f7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3bbe4e422af1ea7004cb55f5cd167b8713ae756b910de3fca8314802db756f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3bbe4e422af1ea7004cb55f5cd167b8713ae756b910de3fca8314802db756f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3bbe4e422af1ea7004cb55f5cd167b8713ae756b910de3fca8314802db756f4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/codeburn report --period today --format json")
    assert_match "\"generated\"", output
    assert_match "\"period\":", output
    assert_match "\"overview\"", output
  end
end
