require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.20.1.tgz"
  sha256 "23c3031a2b8943b6dcc96721d128c1f1f01a8a60087b7dc5506185661d678aa9"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e9693ce46ef4ce6aa915053860934b3ad9d8c6d393d635a573e44f64f5d9242" => :catalina
    sha256 "fb4caca71a95fb5f5f09f0ec56665c6a06a861276772ee400edb5741525767d5" => :mojave
    sha256 "907d6b07bb24a78c99c0a5ea9d42aa3cdfb470f5e51ba38937ca71847463088b" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
