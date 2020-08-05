require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.12.0.tgz"
  sha256 "91cc56907d6c77295e1e4628e52fa272d46a9cfdd8b8db364edbdb8840128c80"
  license "Apache-2.0"

  bottle do
    sha256 "c0f34d4730d9992e84a5661bcf31d5e1a498dc86b0ed90679092cd1c552a1a5c" => :catalina
    sha256 "9bc205b3086181600c944d6fec722c18d419d5917cbe7d4acc5b27192affea30" => :mojave
    sha256 "6d23b4afd857b75527a3530eda3258813a968f53c6da036bad3fab156c83b642" => :high_sierra
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
