require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.27.4.tgz"
  sha256 "bbae623611e1171c17f993fea3eb5dcc0c4c4d41cbaa8bb30d25164e31ba6f58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "490e7faf79a7de0a3ae9f3c3216003eae61f760b299aa95349e4d5ae321f5d57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "490e7faf79a7de0a3ae9f3c3216003eae61f760b299aa95349e4d5ae321f5d57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "490e7faf79a7de0a3ae9f3c3216003eae61f760b299aa95349e4d5ae321f5d57"
    sha256 cellar: :any_skip_relocation, sonoma:         "3968245fd7db84f715852f30e6a9d3262160ff6ccfa6ed54e28b222a6c86b1f4"
    sha256 cellar: :any_skip_relocation, ventura:        "3968245fd7db84f715852f30e6a9d3262160ff6ccfa6ed54e28b222a6c86b1f4"
    sha256 cellar: :any_skip_relocation, monterey:       "3968245fd7db84f715852f30e6a9d3262160ff6ccfa6ed54e28b222a6c86b1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "490e7faf79a7de0a3ae9f3c3216003eae61f760b299aa95349e4d5ae321f5d57"
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
