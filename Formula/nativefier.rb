require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-43.1.2.tgz"
  sha256 "f8681c081f41a71f9c1a089e24f0f97151888a0f5e1783af1e013a1ec99ac5e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01a0e10cf50487591320023f879033d5949991f5bc9c10090eb8cf276159dc5f"
    sha256 cellar: :any_skip_relocation, big_sur:       "41a643633cee32f9908a882583cd28243539f8a7281aaabb0a79f071f9d02718"
    sha256 cellar: :any_skip_relocation, catalina:      "41a643633cee32f9908a882583cd28243539f8a7281aaabb0a79f071f9d02718"
    sha256 cellar: :any_skip_relocation, mojave:        "41a643633cee32f9908a882583cd28243539f8a7281aaabb0a79f071f9d02718"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
