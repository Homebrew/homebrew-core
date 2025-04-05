class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.34.tgz"
  sha256 "b4900455cd9f67e18acf786632732aecd21f5d5a939a3082ac3557e35df96996"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edf9fd4c0029cf8a0d4d215930556f1fb2968c6461178a07f527d37daff7ce0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edf9fd4c0029cf8a0d4d215930556f1fb2968c6461178a07f527d37daff7ce0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edf9fd4c0029cf8a0d4d215930556f1fb2968c6461178a07f527d37daff7ce0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5f998041a5836469c277423fa16b4d700279588f0b662b14f8c4e2da6638951"
    sha256 cellar: :any_skip_relocation, ventura:       "e5f998041a5836469c277423fa16b4d700279588f0b662b14f8c4e2da6638951"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edf9fd4c0029cf8a0d4d215930556f1fb2968c6461178a07f527d37daff7ce0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edf9fd4c0029cf8a0d4d215930556f1fb2968c6461178a07f527d37daff7ce0b"
  end

  depends_on "node@22"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
