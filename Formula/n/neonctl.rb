require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.26.2.tgz"
  sha256 "400d9a6645d44ff21e783a79fde69d9c5a80837aff97e61e321b9b17b836aa0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60d497d52a26c9d034354dd71b519966f8fd0b7c81cf904d089c8151c824dc52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60d497d52a26c9d034354dd71b519966f8fd0b7c81cf904d089c8151c824dc52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60d497d52a26c9d034354dd71b519966f8fd0b7c81cf904d089c8151c824dc52"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3c3b1c7418d020e36d4cab1f76267a4cf448e45eb7204d02616e1492d0ce3ca"
    sha256 cellar: :any_skip_relocation, ventura:        "d3c3b1c7418d020e36d4cab1f76267a4cf448e45eb7204d02616e1492d0ce3ca"
    sha256 cellar: :any_skip_relocation, monterey:       "d3c3b1c7418d020e36d4cab1f76267a4cf448e45eb7204d02616e1492d0ce3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60d497d52a26c9d034354dd71b519966f8fd0b7c81cf904d089c8151c824dc52"
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
