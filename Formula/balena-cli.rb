require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.35.18.tgz"
  sha256 "392f5975f99b822439f32ef828322b4a7e7fc967a8e47592c16caa45f62d1cc7"

  bottle do
    sha256 "cb303b01264fa8b01bc49d774315bf8d1c2ade9e774ac33ff79c30ed41b3b68f" => :catalina
    sha256 "6bf9d612d73042bda6571dc6a75228418ad9f006a478531eeee6e03c6d582b15" => :mojave
    sha256 "36c89245274cbd193e8323b6fe021ce5e82461b7dcada05b7dba46928ff3b624" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
