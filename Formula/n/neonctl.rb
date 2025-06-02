class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.10.1.tgz"
  sha256 "17aa0944f9f4703e6b288b642d243770e13f9e4b8e68b9b1514bf294e36689b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fe8d2d0403e5b91e0486c3092f836a7bbb945af1e70b5287652909ed8d6a54d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fe8d2d0403e5b91e0486c3092f836a7bbb945af1e70b5287652909ed8d6a54d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fe8d2d0403e5b91e0486c3092f836a7bbb945af1e70b5287652909ed8d6a54d"
    sha256 cellar: :any_skip_relocation, sonoma:        "52b18e57a55ec58d254189d256c57fc3c5f71242dfcd65a65f8406b1d95a6c94"
    sha256 cellar: :any_skip_relocation, ventura:       "52b18e57a55ec58d254189d256c57fc3c5f71242dfcd65a65f8406b1d95a6c94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fe8d2d0403e5b91e0486c3092f836a7bbb945af1e70b5287652909ed8d6a54d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fe8d2d0403e5b91e0486c3092f836a7bbb945af1e70b5287652909ed8d6a54d"
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
