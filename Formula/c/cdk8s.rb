class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.100.tgz"
  sha256 "219f84c4c4499c086377cd6be7c0ea5e3f1e2e6f588785e890c9388a5705ac15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b58390b893c0eeb33c6ae31f20220053560c2ead26f74967a3f85dcc04dde994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b58390b893c0eeb33c6ae31f20220053560c2ead26f74967a3f85dcc04dde994"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b58390b893c0eeb33c6ae31f20220053560c2ead26f74967a3f85dcc04dde994"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ea8511056b509fbff8f1ea509b8148a436382a3cf6cac381c38bfe074a2796b"
    sha256 cellar: :any_skip_relocation, ventura:       "0ea8511056b509fbff8f1ea509b8148a436382a3cf6cac381c38bfe074a2796b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b58390b893c0eeb33c6ae31f20220053560c2ead26f74967a3f85dcc04dde994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b58390b893c0eeb33c6ae31f20220053560c2ead26f74967a3f85dcc04dde994"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
