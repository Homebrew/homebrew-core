require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.13.0.tgz"
  sha256 "635aad5b911fd8f723da1511eae384ad9ab29f33cc4f487350218c95bf64e8eb"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "85e5bbdc92d1fd4507523e11a02cf4d900d91d948bf78fd45c5ee7a0c9eec7e6"
    sha256                               arm64_monterey: "b6bf5f0d4bcb0ac5823a248df4d5f03693ee5c5ab8beff81cc79f9ad65ecaa28"
    sha256                               arm64_big_sur:  "34640b1f295ea3e97617544293fdb88d2f0434b7b2a175a7f2f4c52104625317"
    sha256                               ventura:        "3471e12e24105ba5ed75cefe9517ce29282dcad036f298245016bc1f3591b4ce"
    sha256                               monterey:       "d42c132ca5fda425fda0af1065543bb979a856b99b1b76b4547ca9a90d853a71"
    sha256                               big_sur:        "66d1932f1b1117fd353e5aef6c780f02fd58b3f35d0af42bcfec417432d1b18f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68930e80125831e172ea0c7c4ba3f2c4e941b3e184b9ef55dc34ee38bbfa0719"
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
