require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-13.0.0.tgz"
  sha256 "f05f234277b21d8e71018ae9fe606a443794e369c4a22c947de8c87f7f99cd55"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "0d6a499f36a2a44a167f378da792238397b528d2c3ee187de8ea03365f766d45"
    sha256                               arm64_monterey: "c5abccc3d8ec6484dc352d313b6e01004dfb0f763d6d97e964aed47709f47fab"
    sha256                               arm64_big_sur:  "3e9f31112686a857bfa93a372d6072c553315a448d2babfc0e2349e888cf5014"
    sha256                               ventura:        "710511f89819bdc510f7a6c92c5e5a6dbc01f46aa7f0996b4e7f0d18cacff5bc"
    sha256                               monterey:       "a026c2f34d15a3e4144ddb1473c9f0a881e8ad7c9177988271e5191f9b6b5901"
    sha256                               big_sur:        "be3d0d28c4de7e96489651e7b5af42dbac154baf98488b2ee12739f99cb16a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1d78111fdea08ad881026122854b0d18f7fdf878456398f9a0423f34bbb3ef6"
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
