class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.9.7.tgz"
  sha256 "425840540f61313597aeb85b836c8452704019e3833e315c3790797780486801"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d3597348fc1c3e34317a44a4f74c51503a41e3eec94a8d923ef0021e7c8f5665"
    sha256                               arm64_sequoia: "d3597348fc1c3e34317a44a4f74c51503a41e3eec94a8d923ef0021e7c8f5665"
    sha256                               arm64_sonoma:  "d3597348fc1c3e34317a44a4f74c51503a41e3eec94a8d923ef0021e7c8f5665"
    sha256 cellar: :any_skip_relocation, sonoma:        "561623491daa59ae1b0b89bac8b05854e7a3e52720597554918a1db6c7d56a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f1bd2d525d04041f77256b99fda6aaea7796cca2f6ce6de80436c3fca0b237"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
