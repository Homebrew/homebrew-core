require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.4.2.tgz"
  sha256 "365b8b50ffb025c8a12e9d54ecc99b285ce5d788ade5f3af32ec022f701234c3"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "e1b5a8588ee78035a9606226f3ca4c357db9fac31db8399765791ed570e2dbfe"
    sha256                               arm64_monterey: "e0e5c388f8ce7f1d9efc22565cc6906b5c655c4a3ba59dd9ae2ee8dd3d045389"
    sha256                               arm64_big_sur:  "fb76e5c3bf9113131633b5f9575830811f040d1cdb5ffdafd441cf6894988607"
    sha256                               ventura:        "d2c7d7a87cbfe8286f3b6a113937c88a2fd58b505e5878b01a17f92c22c5d8e3"
    sha256                               monterey:       "99e26f19101f67057444777a9ac3462e87d5379ef61af8ebd33d58fafe1be094"
    sha256                               big_sur:        "0eaa71979c37e99cc96a05d49f2102303bc16eecdffdc1890d892a3f01dc610f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "651df62a4661d12da57bcb9873695eb75b5232bcc1b2549ec9eb838d6aa2f5e1"
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
