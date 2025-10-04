class Basti < Formula
  desc "Securely connect to RDS, Elasticache, and other AWS resources in VPCs"
  homepage "https://github.com/basti-app/basti"
  url "https://registry.npmjs.org/basti/-/basti-1.7.1.tgz"
  sha256 "a3105943b1ca2efd2f756f2e381725a3668ea30fe2edb3d2436d8c2fb2df81a5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a296b5913e1133e38aacc80ede21ea2365a81968fc7388ff40444c7297cf1d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a296b5913e1133e38aacc80ede21ea2365a81968fc7388ff40444c7297cf1d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a296b5913e1133e38aacc80ede21ea2365a81968fc7388ff40444c7297cf1d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c09e86846c6d8f06e61670814d87b8eac49b573269ccd69d16be287fc1763c5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6520d532671da396cd7784bc24d376a45a43f7994c380314f91dbbc12131a709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9561a9df50959ab856ceeed526761dc1f455c3f17852dbe5ea3d9d7e885d3d8b"
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
