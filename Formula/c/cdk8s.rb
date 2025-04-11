class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.39.tgz"
  sha256 "7a8724966ac1ead15a4b04a5bfc651cc3e39ad1ad3466ebc1f7669dd263824c5"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7843fddaf055f673b449ec48479bee555b246e4b4fd2156416b6d11a71d7356b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7843fddaf055f673b449ec48479bee555b246e4b4fd2156416b6d11a71d7356b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7843fddaf055f673b449ec48479bee555b246e4b4fd2156416b6d11a71d7356b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a503c1937bb077e688ae4fc5d875a2cde6c0bd69f46b5d5eb3fc1061bb6703a"
    sha256 cellar: :any_skip_relocation, ventura:       "2a503c1937bb077e688ae4fc5d875a2cde6c0bd69f46b5d5eb3fc1061bb6703a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7843fddaf055f673b449ec48479bee555b246e4b4fd2156416b6d11a71d7356b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7843fddaf055f673b449ec48479bee555b246e4b4fd2156416b6d11a71d7356b"
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
