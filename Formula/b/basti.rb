class Basti < Formula
  desc "Securely connect to RDS, Elasticache, and other AWS resources in VPCs"
  homepage "https://www.basti.app"
  url "https://registry.npmjs.org/basti/-/basti-1.8.1.tgz"
  sha256 "cfcda8ebe4f095a5b891a471174787d7ea07c5ea6c06fdd02e44803d42d5e358"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59fc015b7eddf0fbbee6f2958303dc5783db3b5a08e34bda33f561e3300eb4c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "59fc015b7eddf0fbbee6f2958303dc5783db3b5a08e34bda33f561e3300eb4c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59fc015b7eddf0fbbee6f2958303dc5783db3b5a08e34bda33f561e3300eb4c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5f8a98b169a32f582d666126efc0407ab6e30acb567cd8343ec2ebae8bd755c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e510536da45e982b9387c062e5a18a1e2db89ac8c0f93145ceed8907e2ec2a8f"
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
