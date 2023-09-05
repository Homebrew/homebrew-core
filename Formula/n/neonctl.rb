require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.21.3.tgz"
  sha256 "75345407576a1a8e869fb17d922fdf6a296706bf08154cd32ecea66652e1602d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6ed3e24f8d39a778b21f91750b7fa6c60f2d5b5dabab1fa73dcd79835bfc8bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6ed3e24f8d39a778b21f91750b7fa6c60f2d5b5dabab1fa73dcd79835bfc8bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6ed3e24f8d39a778b21f91750b7fa6c60f2d5b5dabab1fa73dcd79835bfc8bb"
    sha256 cellar: :any_skip_relocation, ventura:        "b301daf538e2161694c4826f92bdff7ca10c7a858102c86bdde5d9569313d828"
    sha256 cellar: :any_skip_relocation, monterey:       "b301daf538e2161694c4826f92bdff7ca10c7a858102c86bdde5d9569313d828"
    sha256 cellar: :any_skip_relocation, big_sur:        "b301daf538e2161694c4826f92bdff7ca10c7a858102c86bdde5d9569313d828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6ed3e24f8d39a778b21f91750b7fa6c60f2d5b5dabab1fa73dcd79835bfc8bb"
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
