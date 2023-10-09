require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.22.0.tgz"
  sha256 "b4a80744529e3862896da825cfa10e11c693dab6f39e6122d6e94f3bfac96982"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22f5ebafc95c15e92482c369160235c5dac41982ee81529897934d394da8c180"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22f5ebafc95c15e92482c369160235c5dac41982ee81529897934d394da8c180"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22f5ebafc95c15e92482c369160235c5dac41982ee81529897934d394da8c180"
    sha256 cellar: :any_skip_relocation, sonoma:         "24e55e8035418d9e5eefba3169f76f02ead80cec4e2b5a25e91feb29aefb4ac3"
    sha256 cellar: :any_skip_relocation, ventura:        "24e55e8035418d9e5eefba3169f76f02ead80cec4e2b5a25e91feb29aefb4ac3"
    sha256 cellar: :any_skip_relocation, monterey:       "24e55e8035418d9e5eefba3169f76f02ead80cec4e2b5a25e91feb29aefb4ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22f5ebafc95c15e92482c369160235c5dac41982ee81529897934d394da8c180"
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
