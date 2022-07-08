require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-5.1.8.tgz"
  sha256 "96a2982e085ac6aa6966a71a615143f37ca923b80eb79c232cafcfe2594f8b2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "180266cccebf39a68e4cf07e4ef1a8d02bba01d185e3e6bca92d75336a41d60e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "180266cccebf39a68e4cf07e4ef1a8d02bba01d185e3e6bca92d75336a41d60e"
    sha256 cellar: :any_skip_relocation, monterey:       "e8d40bb73dca0486c476c06db61f0e600de52c2e4866bad0c151b3da6871dfec"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8d40bb73dca0486c476c06db61f0e600de52c2e4866bad0c151b3da6871dfec"
    sha256 cellar: :any_skip_relocation, catalina:       "e8d40bb73dca0486c476c06db61f0e600de52c2e4866bad0c151b3da6871dfec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180266cccebf39a68e4cf07e4ef1a8d02bba01d185e3e6bca92d75336a41d60e"
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
