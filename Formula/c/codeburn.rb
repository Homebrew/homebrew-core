class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.15.tgz"
  sha256 "343b11c8e70fbeb2694d81000ca86d34168faf7a1452cb5478dafae09eecdb1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7af104d664becc302884ecf42722d85f82c1c9cd584764befa06c067a918e7d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7af104d664becc302884ecf42722d85f82c1c9cd584764befa06c067a918e7d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7af104d664becc302884ecf42722d85f82c1c9cd584764befa06c067a918e7d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "49eca6dbc5f5b164269a4e0e0b8a26b31731cc1db7c12c6e726b3616f8ed3a58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49eca6dbc5f5b164269a4e0e0b8a26b31731cc1db7c12c6e726b3616f8ed3a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49eca6dbc5f5b164269a4e0e0b8a26b31731cc1db7c12c6e726b3616f8ed3a58"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/codeburn report --period today --format json")
    assert_match "\"generated\"", output
    assert_match "\"period\":", output
    assert_match "\"overview\"", output
  end
end
