require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-14.2.1.tgz"
  sha256 "7179eda631d46487d5afd663a1046874bf52a49c72b562ba5205693e2ad3c8fb"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "84b2320d3f53ef2a6e44b220732090a74bca39079465712f447832d24279d040"
    sha256                               arm64_monterey: "03b6bac48d240bf11ff1f3264c7df0d666467228112d5f90a7c1d8ef4c163943"
    sha256                               arm64_big_sur:  "23fd4fe737fc6820150d06632a085fec221a7a3141239f357c8455377be972e9"
    sha256                               ventura:        "ec5bafe7092293c74f489811fb1bec1e43530f773c8fe6e80868e1a93e59d785"
    sha256                               monterey:       "ad59722bef9d3944e46c2a403dbad621acc6be559acc9da729e4377eecd2e808"
    sha256                               big_sur:        "bb6dd0f4cdede854006572371cecbb2d49aa50e48df8f0b57eb5672acd10d5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a339c87a0d1e3d4bb88862efaac7cb29213726ec46b0649c1379818c01ea4ad6"
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
