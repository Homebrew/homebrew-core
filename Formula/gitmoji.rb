require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-7.1.0.tgz"
  sha256 "044caf2a03cf0728bc0344ce7133816bb7a1f854d443f0a8b18f6f4cae0981b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab510c8e163ceda1c873eb359967a5a695697de8f98278a16820ab5abf34d692"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab510c8e163ceda1c873eb359967a5a695697de8f98278a16820ab5abf34d692"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab510c8e163ceda1c873eb359967a5a695697de8f98278a16820ab5abf34d692"
    sha256 cellar: :any_skip_relocation, ventura:        "399e51b3ebdd757ededd5240e25c5977f21990efb87cf446d889ae5d60fb00b8"
    sha256 cellar: :any_skip_relocation, monterey:       "399e51b3ebdd757ededd5240e25c5977f21990efb87cf446d889ae5d60fb00b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "399e51b3ebdd757ededd5240e25c5977f21990efb87cf446d889ae5d60fb00b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab510c8e163ceda1c873eb359967a5a695697de8f98278a16820ab5abf34d692"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
