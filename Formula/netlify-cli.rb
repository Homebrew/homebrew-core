require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.5.0.tgz"
  sha256 "cf6a433519783e7a5448b1405814d96e84f897295b7d8348cfccb87c55d53a58"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "821bbc8508c76d041eb181217a89b53b2521bf07f16e2c6f6cc621798022aea4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "821bbc8508c76d041eb181217a89b53b2521bf07f16e2c6f6cc621798022aea4"
    sha256 cellar: :any_skip_relocation, monterey:       "4d1a04d97d28aa3d12d6c55bcc206f4e115705d1e229d251142ed16dc15fdd32"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d1a04d97d28aa3d12d6c55bcc206f4e115705d1e229d251142ed16dc15fdd32"
    sha256 cellar: :any_skip_relocation, catalina:       "4d1a04d97d28aa3d12d6c55bcc206f4e115705d1e229d251142ed16dc15fdd32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe6ca3266bbe19abaa899d3c5f25896856a44a607747542943073a62fd79c5d5"
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
