require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.18.2.tgz"
  sha256 "c0bb231cd2501b7de7e2fed2d76f76b67ba1088889c52d4bb34efcc032ad48bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5ba8c27fd0062ea7b080394e802b6f7060f1c672602e4789c25a10bbdadc756" => :catalina
    sha256 "1ce71f5d0d5ea522451ce47ea87dddb234e2fab923dd02c3d18b53d81755f047" => :mojave
    sha256 "f124e42a79988d08e4003e91a53d33c4519d2c0539dd58ea298967f231b12458" => :high_sierra
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
