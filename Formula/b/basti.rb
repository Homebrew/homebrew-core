class Basti < Formula
  desc "Securely connect to RDS, Elasticache, and other AWS resources in VPCs"
  homepage "https://github.com/basti-app/basti"
  url "https://registry.npmjs.org/basti/-/basti-1.8.0.tgz"
  sha256 "aa64f5afecf7cf43c742034a9ca694fa97a5db0b86be6bb77cfcdc2474cd8011"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64c30be06e2812a62d8645ac8224ac1bcf8ba84b9f993ddb65c182f4c07dc96c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64c30be06e2812a62d8645ac8224ac1bcf8ba84b9f993ddb65c182f4c07dc96c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64c30be06e2812a62d8645ac8224ac1bcf8ba84b9f993ddb65c182f4c07dc96c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e667fd26c10bbe9d4fb3d5ad0a4042ec29c144b17733d2c2839c1a8e564b61c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c43a4c0269decf3198c9d4611e1dd609ee4e9598ceead3b423b1a2f33f8e100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8059a8823d2037b431bba1721772ca44fcebed1a8b7ad326c093058ec52fedf3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
