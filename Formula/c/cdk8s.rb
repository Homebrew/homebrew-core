class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.32.tgz"
  sha256 "ff0118905d617def1a482e78076047d90902683ec9bbc5a75a7bf417169a6af3"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd72cb0cf6234389a2f2839bcf4e1dd2de4c838d547ade361edd230fb2e8853d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd72cb0cf6234389a2f2839bcf4e1dd2de4c838d547ade361edd230fb2e8853d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd72cb0cf6234389a2f2839bcf4e1dd2de4c838d547ade361edd230fb2e8853d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5ff45f04ade20fe6ac7a72ba21ebb2c04ae2cc7e84fb2add80ccfed6903e53b"
    sha256 cellar: :any_skip_relocation, ventura:       "e5ff45f04ade20fe6ac7a72ba21ebb2c04ae2cc7e84fb2add80ccfed6903e53b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd72cb0cf6234389a2f2839bcf4e1dd2de4c838d547ade361edd230fb2e8853d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd72cb0cf6234389a2f2839bcf4e1dd2de4c838d547ade361edd230fb2e8853d"
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
