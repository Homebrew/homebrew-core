class Basti < Formula
  desc "Securely connect to RDS, Elasticache, and other AWS resources in VPCs"
  homepage "https://github.com/basti-app/basti"
  url "https://registry.npmjs.org/basti/-/basti-1.7.2.tgz"
  sha256 "92937b3bf012ea34a0435b21dce634ecff724c9a1580ecf0a3850f1365ce5e7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c93ea7546c6c4ed6f890169f332f28810658e4b68d864f965f2e77214e7b445b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c93ea7546c6c4ed6f890169f332f28810658e4b68d864f965f2e77214e7b445b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c93ea7546c6c4ed6f890169f332f28810658e4b68d864f965f2e77214e7b445b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a5cc4bd8ada263464e590c898b0dd980e35b8d53fa68a5fce9fde2897e5d6ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04d05f5fab473c324a8e001be4b880ba1c129e0e3b15e766c71179787352b784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebb576e2bda22c4bf10be9e06b9f2d5ba2ddd906cb53580ca2113865f6b6539f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binary, session-manager-plugin
    node_modules = libexec/"lib/node_modules/basti/node_modules"
    node_modules.glob("basti-session-manager-binary-*/*").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end

    generate_completions_from_executable(bin/"basti", "completion",
                                            shells:                 [:bash, :zsh],
                                            shell_parameter_format: :none)
  end

  test do
    output = shell_output("#{bin}/basti cleanup")
    assert_match "No Basti-managed resources found in your account", output

    assert_match version.to_s, shell_output("#{bin}/basti --version")
  end
end
