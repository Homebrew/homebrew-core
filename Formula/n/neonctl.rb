require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.27.6.tgz"
  sha256 "10b6b77b6ca2774dc6c8c2635f607f84f3f2183c52558c1e896dfaacf3ef1dd8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59bf539aca2c1d6c92dc04d7ca6e5b4e1d4393484a1b40616a919e4139a6fe71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59bf539aca2c1d6c92dc04d7ca6e5b4e1d4393484a1b40616a919e4139a6fe71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59bf539aca2c1d6c92dc04d7ca6e5b4e1d4393484a1b40616a919e4139a6fe71"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c328e3108605b40da1747dcbd96001e74df5901c99e16a199144006d9451955"
    sha256 cellar: :any_skip_relocation, ventura:        "5c328e3108605b40da1747dcbd96001e74df5901c99e16a199144006d9451955"
    sha256 cellar: :any_skip_relocation, monterey:       "5c328e3108605b40da1747dcbd96001e74df5901c99e16a199144006d9451955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59bf539aca2c1d6c92dc04d7ca6e5b4e1d4393484a1b40616a919e4139a6fe71"
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
