class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.0.0.tgz"
  sha256 "7dec75d0c247adc8d4aea131408b2ed8615f8a2f865604eaf55b3324dad380ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76fa5a431aefba7cdceca7db48c79b16a1523567908fa0cbe4e18344b695e777"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76fa5a431aefba7cdceca7db48c79b16a1523567908fa0cbe4e18344b695e777"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76fa5a431aefba7cdceca7db48c79b16a1523567908fa0cbe4e18344b695e777"
    sha256 cellar: :any_skip_relocation, sonoma:        "a87fe5640a292eed98aaf8f2a5ffa3dda907732e5c654a958701c884ef5f26c9"
    sha256 cellar: :any_skip_relocation, ventura:       "a87fe5640a292eed98aaf8f2a5ffa3dda907732e5c654a958701c884ef5f26c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76fa5a431aefba7cdceca7db48c79b16a1523567908fa0cbe4e18344b695e777"
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
