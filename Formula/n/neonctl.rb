class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.2.0.tgz"
  sha256 "4352fbc3e34b086d5036ad2fa693ad89238157a3b8716562740856afb317ce3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "314f7b3c6e914162121ba731c91a5d9c89e6677f00083a09694ad196b945bdd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "314f7b3c6e914162121ba731c91a5d9c89e6677f00083a09694ad196b945bdd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "314f7b3c6e914162121ba731c91a5d9c89e6677f00083a09694ad196b945bdd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4cfd6d366b8f8420a02c541fea692b47b4884ddae2f5f1e4f1988cfb24657ec"
    sha256 cellar: :any_skip_relocation, ventura:       "f4cfd6d366b8f8420a02c541fea692b47b4884ddae2f5f1e4f1988cfb24657ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "314f7b3c6e914162121ba731c91a5d9c89e6677f00083a09694ad196b945bdd7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", base_name: cmd, shells: [:bash, :zsh])
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end
