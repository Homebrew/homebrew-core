require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.0.0.tgz"
  sha256 "ec4c9e90d27f565c80984ad44c8f375a2ee86a3b4d265483ea631424b3f08175"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "fe59665151453d3a82cfebe3827552e3c8db55ab3846be8b6b1d15189e1edc9e"
    sha256                               arm64_ventura:  "b64b57e512714d8833378fe6c49abc398fea5257287bcb6bc10a0c97d3574614"
    sha256                               arm64_monterey: "2a2a07e53e1d99ae121374996a46f50fd2f14fdde2bd5ff9e795b9a15ef01583"
    sha256                               sonoma:         "7ce5b5424de839b54fcd12342bf8e32c0837938b55231731efb2addc2db9dce1"
    sha256                               ventura:        "39c376a516f78a0d25f5264a7a533c945798e93948f7a574a1bd47cc0d10c5c9"
    sha256                               monterey:       "54c8466520241d7b9e856e5b3af84b226c4c70f2a5d14df5c0a48755d3fd87a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e388b509fe5cb106e680337896bbadfe4b1161c5719ea0675100013e7d507468"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    if OS.linux?
      node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
