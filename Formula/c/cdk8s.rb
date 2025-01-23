class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.301.tgz"
  sha256 "325a5728c48ec191fadd24309553fbec6ec8484e80c049d47b16595030b15f44"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9367bba42a55bea2d6e075e18c7885415f92d182b3e6605f768c669e9ccd9e73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9367bba42a55bea2d6e075e18c7885415f92d182b3e6605f768c669e9ccd9e73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9367bba42a55bea2d6e075e18c7885415f92d182b3e6605f768c669e9ccd9e73"
    sha256 cellar: :any_skip_relocation, sonoma:        "f427bbac5e08951e98e69ba0ffb3606414b5cb775540fd9cab5a314716e6168c"
    sha256 cellar: :any_skip_relocation, ventura:       "f427bbac5e08951e98e69ba0ffb3606414b5cb775540fd9cab5a314716e6168c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9367bba42a55bea2d6e075e18c7885415f92d182b3e6605f768c669e9ccd9e73"
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
