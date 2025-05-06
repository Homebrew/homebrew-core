class Basti < Formula
  desc "Securely connect to RDS, Elasticache, and other AWS resources in VPCs"
  homepage "https://github.com/basti-app/basti"
  url "https://registry.npmjs.org/basti/-/basti-1.7.1.tgz"
  sha256 "a3105943b1ca2efd2f756f2e381725a3668ea30fe2edb3d2436d8c2fb2df81a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0549ae3e2472e1e53c820caf50872ed6d3f124c05ccfbd7a8a98386406ecbbe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0549ae3e2472e1e53c820caf50872ed6d3f124c05ccfbd7a8a98386406ecbbe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0549ae3e2472e1e53c820caf50872ed6d3f124c05ccfbd7a8a98386406ecbbe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2da4b1374a33cfb194b65260ca559b7a93f75b21a081d0643764597351b6b2cc"
    sha256 cellar: :any_skip_relocation, ventura:       "2da4b1374a33cfb194b65260ca559b7a93f75b21a081d0643764597351b6b2cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0e04e4ab6509d397dff2273c18f8fb28d71fa5e60a5f1c27fabfb7a1d2fc7e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d31d3a8cf98a28daf71345f66b0730740f606b5397af215bcde8d3e9bc57a25"
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
