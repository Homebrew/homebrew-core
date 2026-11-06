class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.78.tgz"
  sha256 "fe6569c7f81762189b348727c6c84c8e0a9fc9752611edc39eefbb8edf9d5f83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "244f936cf31b04c96d192b6f522e36186b7e895c3de78db00fd9333c0d8b4c0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6fe130ee4394f399a8106ffcadc93b478525cf4345702d842c8b5108b44c612b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "244f936cf31b04c96d192b6f522e36186b7e895c3de78db00fd9333c0d8b4c0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6fe130ee4394f399a8106ffcadc93b478525cf4345702d842c8b5108b44c612b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6fe130ee4394f399a8106ffcadc93b478525cf4345702d842c8b5108b44c612b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
