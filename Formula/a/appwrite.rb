class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-13.0.0.tgz"
  sha256 "6834da4e136706e36d795786b9d345877212968a9de7acf81fd9bf4eae4438f7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "062de40f281089ac0eafa03554786bfbd6b182ed7e5379927f8ca1094f554ad5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e1e6b58997cda56c0e8004b1dce0b20e0ed5fb5525e2dde34fa546ef3a4d833"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e1e6b58997cda56c0e8004b1dce0b20e0ed5fb5525e2dde34fa546ef3a4d833"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9c56b65e8f87fa66042c849a9429f11fff6b840e1bb56dffd2e21b382d5f27f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5443b2738abcca2f9d5150ceb04b209d80d93201ac3cda76e776f748688c9627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5443b2738abcca2f9d5150ceb04b209d80d93201ac3cda76e776f748688c9627"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
