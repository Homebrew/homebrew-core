class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.40.tgz"
  sha256 "537439cfa351104e7dff4741db2cc58c7cc6defa15267aaaf602ea68b1159f02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cefed84da0f4b6b99b37a8f3e99861da17cf74e60e29f93c538d8bd5e0680508"
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
