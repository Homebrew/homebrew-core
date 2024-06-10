require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.30.0.tgz"
  sha256 "be5d70ecad37952185c66e377a6443022b11f6069b885466b394d5b95727c118"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81b88bbe37add11a457a0f05dece0601d4af35821e7507002237098e6fa4792e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81b88bbe37add11a457a0f05dece0601d4af35821e7507002237098e6fa4792e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81b88bbe37add11a457a0f05dece0601d4af35821e7507002237098e6fa4792e"
    sha256 cellar: :any_skip_relocation, sonoma:         "60b297f2616e5a859c0196baec11a2e1f3db3dc918ad9694298c91afab5c08d8"
    sha256 cellar: :any_skip_relocation, ventura:        "60b297f2616e5a859c0196baec11a2e1f3db3dc918ad9694298c91afab5c08d8"
    sha256 cellar: :any_skip_relocation, monterey:       "60b297f2616e5a859c0196baec11a2e1f3db3dc918ad9694298c91afab5c08d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f42bbba46d71ed5eb2c8f2a18a78c48a81dfda8d5d7d97a6df70c6a59a16231d"
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
