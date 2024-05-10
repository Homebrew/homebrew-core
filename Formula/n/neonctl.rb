require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.29.3.tgz"
  sha256 "6fb1cfe58c9a967df8f9d3c1e6d30a13d62b3186f26dc4bfde7b931c353c1dad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfaa1bffa591d7093e8517224b91b2219d4c6cd54e97b5e412a9c996ce261524"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfaa1bffa591d7093e8517224b91b2219d4c6cd54e97b5e412a9c996ce261524"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfaa1bffa591d7093e8517224b91b2219d4c6cd54e97b5e412a9c996ce261524"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac1e1c224ba9d1a302a6565589358e21f4f86d7bb47dc77bcc79636db5c1326e"
    sha256 cellar: :any_skip_relocation, ventura:        "ac1e1c224ba9d1a302a6565589358e21f4f86d7bb47dc77bcc79636db5c1326e"
    sha256 cellar: :any_skip_relocation, monterey:       "ac1e1c224ba9d1a302a6565589358e21f4f86d7bb47dc77bcc79636db5c1326e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfaa1bffa591d7093e8517224b91b2219d4c6cd54e97b5e412a9c996ce261524"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end
