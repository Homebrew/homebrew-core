require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.7.0.tgz"
  sha256 "efca89076a4697a95cda3de4a33a796382653e3af1007b84541e93aad50a6e3f"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab0c19cfa690856db1a2ae9dbbe97b588a54dbe3c458f6b823c3457d79992429"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab0c19cfa690856db1a2ae9dbbe97b588a54dbe3c458f6b823c3457d79992429"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab0c19cfa690856db1a2ae9dbbe97b588a54dbe3c458f6b823c3457d79992429"
    sha256 cellar: :any_skip_relocation, ventura:        "845516675de00d08e7eb371e282fa58ed3b8446875c8e506a76d50119bd205a3"
    sha256 cellar: :any_skip_relocation, monterey:       "845516675de00d08e7eb371e282fa58ed3b8446875c8e506a76d50119bd205a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "845516675de00d08e7eb371e282fa58ed3b8446875c8e506a76d50119bd205a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "569378cb9f8a0dbfc16c81c374b1c172fcaca042eeb988970e4498f55943d9e1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
