class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.6.0.tgz"
  sha256 "8e0b1985e6a4acbc5405f4fc4ceed147e500472a10b27eee691e606e852d6869"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "545624d518766da1aa50efcc11c3c5800cdfe938e14759af1e4707bdc4e4ad8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "545624d518766da1aa50efcc11c3c5800cdfe938e14759af1e4707bdc4e4ad8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "545624d518766da1aa50efcc11c3c5800cdfe938e14759af1e4707bdc4e4ad8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eea08391deae349f16fbef98d88bd3889df6464a628b07013ddc0b997f13d00"
    sha256 cellar: :any_skip_relocation, ventura:       "4eea08391deae349f16fbef98d88bd3889df6464a628b07013ddc0b997f13d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "545624d518766da1aa50efcc11c3c5800cdfe938e14759af1e4707bdc4e4ad8a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh])
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end
