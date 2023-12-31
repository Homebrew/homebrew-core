require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.25.1.tgz"
  sha256 "47733467ea4d592f2a5bfee3e6fea35ea66c6af07222988ed0441440cffbe78c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53e6dcb325802c218cffb4c5d9d4caab15c34cdb7f87031166456fe0f92f0bb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53e6dcb325802c218cffb4c5d9d4caab15c34cdb7f87031166456fe0f92f0bb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53e6dcb325802c218cffb4c5d9d4caab15c34cdb7f87031166456fe0f92f0bb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "67073c97ce71afa44fd1707c7f89aadbc4baea8c5a8d360df9c025ab384bfd81"
    sha256 cellar: :any_skip_relocation, ventura:        "67073c97ce71afa44fd1707c7f89aadbc4baea8c5a8d360df9c025ab384bfd81"
    sha256 cellar: :any_skip_relocation, monterey:       "67073c97ce71afa44fd1707c7f89aadbc4baea8c5a8d360df9c025ab384bfd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53e6dcb325802c218cffb4c5d9d4caab15c34cdb7f87031166456fe0f92f0bb1"
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
