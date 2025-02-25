class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.199.0.tgz"
  sha256 "e979ea4477244589e123761a85fce4fa3d3719a2916603d2f38b9201db817a8d"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1520ef2654f88059ad506fc29879f3b1e143e2f46f2961f8e9363ac590ffd5af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1520ef2654f88059ad506fc29879f3b1e143e2f46f2961f8e9363ac590ffd5af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1520ef2654f88059ad506fc29879f3b1e143e2f46f2961f8e9363ac590ffd5af"
    sha256 cellar: :any_skip_relocation, sonoma:        "1405ba1ac41e5fb5ae3cacc4d33fd24d50afb7425dd7393d722250d68de0b9fa"
    sha256 cellar: :any_skip_relocation, ventura:       "1405ba1ac41e5fb5ae3cacc4d33fd24d50afb7425dd7393d722250d68de0b9fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1520ef2654f88059ad506fc29879f3b1e143e2f46f2961f8e9363ac590ffd5af"
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
