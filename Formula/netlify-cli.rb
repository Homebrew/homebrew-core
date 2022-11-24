require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.2.5.tgz"
  sha256 "63556ff5988373bd1bb5e870eb22d385e7ab7dfd289bfad5509c223c6ebedc33"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "effdc880be48ec328fc58fa82123ea679a2bbad9622eb6b655bfbd77b7d63eea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "effdc880be48ec328fc58fa82123ea679a2bbad9622eb6b655bfbd77b7d63eea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "effdc880be48ec328fc58fa82123ea679a2bbad9622eb6b655bfbd77b7d63eea"
    sha256 cellar: :any_skip_relocation, ventura:        "4b6007af65e4017bcd2992a27582e67c7423161d2a37069f11b527d30a6ea032"
    sha256 cellar: :any_skip_relocation, monterey:       "4b6007af65e4017bcd2992a27582e67c7423161d2a37069f11b527d30a6ea032"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b6007af65e4017bcd2992a27582e67c7423161d2a37069f11b527d30a6ea032"
    sha256 cellar: :any_skip_relocation, catalina:       "4b6007af65e4017bcd2992a27582e67c7423161d2a37069f11b527d30a6ea032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d68562a013ad3079edabd8b01c8f5d68a446430129f091ee058553e93f36d23"
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
