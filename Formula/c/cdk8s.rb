require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.51.tgz"
  sha256 "ad45ae386484ba0be7fdb971fd3e9d4f39f260b1df3923e79361175160cdb977"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cbfb4609d7124d710aeead496ca4d7889648586f35e0b2d6a501f4c03256084"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cbfb4609d7124d710aeead496ca4d7889648586f35e0b2d6a501f4c03256084"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cbfb4609d7124d710aeead496ca4d7889648586f35e0b2d6a501f4c03256084"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dab20e3984b95c9303ff81ab03c392eafec9859e8aa15a04079858f4ffdd8ed"
    sha256 cellar: :any_skip_relocation, ventura:        "7dab20e3984b95c9303ff81ab03c392eafec9859e8aa15a04079858f4ffdd8ed"
    sha256 cellar: :any_skip_relocation, monterey:       "7dab20e3984b95c9303ff81ab03c392eafec9859e8aa15a04079858f4ffdd8ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cbfb4609d7124d710aeead496ca4d7889648586f35e0b2d6a501f4c03256084"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
