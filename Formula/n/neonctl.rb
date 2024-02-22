require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.27.1.tgz"
  sha256 "437075884dd8996c42ab13093ef1224a0d35d4105777f4fcc96b798f1082e345"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a43928c9ac515122a24d65965e4674850d0ea4ffeb013cb2f084dd514b016eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a43928c9ac515122a24d65965e4674850d0ea4ffeb013cb2f084dd514b016eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a43928c9ac515122a24d65965e4674850d0ea4ffeb013cb2f084dd514b016eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff44c4b0a67fd429c238af9ae6a610be716d7fc719b96b84d7be55a97a35b198"
    sha256 cellar: :any_skip_relocation, ventura:        "ff44c4b0a67fd429c238af9ae6a610be716d7fc719b96b84d7be55a97a35b198"
    sha256 cellar: :any_skip_relocation, monterey:       "ff44c4b0a67fd429c238af9ae6a610be716d7fc719b96b84d7be55a97a35b198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a43928c9ac515122a24d65965e4674850d0ea4ffeb013cb2f084dd514b016eb"
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
