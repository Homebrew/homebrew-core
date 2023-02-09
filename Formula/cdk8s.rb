require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.131.tgz"
  sha256 "b1ddbd4a70205eb18d217586137d2444741159f17c4dd58f99ef38291590a558"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ceb7b05c9e2358eb3f4264391bac882d923d9e54e7964845f702acaa0577592"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05aa47deb3ccf84604c3a90384f9b28707cb8b84a8bab2d385ca51d0075c239d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eafc00f2f9ebe2525c391a1ab005d49aa26f9e16482310e66f8be98aef07d843"
    sha256 cellar: :any_skip_relocation, ventura:        "41610fe30eda83292c586f1182c0c415cb19f2d5894645efe828debbd1f7049a"
    sha256 cellar: :any_skip_relocation, monterey:       "38df9108b26bef655c7ff9f6ca7dc196ac88a377f64a4e7ec47ffb69dc8e4045"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6bd7e3c24592c3f55bc8e635ea2ff735fe8f0be3b0cad8dd77f31daf4cf1ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69b6eff78197da5d850eb0b682f5c583fb4a27c55c76f317695dac99abe3b0b1"
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
