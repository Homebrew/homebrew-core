class Basti < Formula
  desc "Securely connect to RDS, Elasticache, and other AWS resources in VPCs"
  homepage "https://github.com/basti-app/basti"
  url "https://registry.npmjs.org/basti/-/basti-1.7.0.tgz"
  sha256 "0651972e9059354dd934b01b08b8f895da7cdaa3ffb52046e318dd10d9f36701"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ff427644cc71dbef154812ea218d9ea3c52058f50eb835a7d5b0442afc80e46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ff427644cc71dbef154812ea218d9ea3c52058f50eb835a7d5b0442afc80e46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ff427644cc71dbef154812ea218d9ea3c52058f50eb835a7d5b0442afc80e46"
    sha256 cellar: :any_skip_relocation, sonoma:        "41122c17de5e710ae0bd301de1358fd35e3995893434a750838c42c4e5004303"
    sha256 cellar: :any_skip_relocation, ventura:       "41122c17de5e710ae0bd301de1358fd35e3995893434a750838c42c4e5004303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ffdeb9e292a573a356abdc46fd03447c88a45c844bdf1c135ac61f22b8244c7"
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
