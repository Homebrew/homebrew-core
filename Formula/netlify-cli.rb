require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-14.0.0.tgz"
  sha256 "3b6d6deb945089739fe4b1f8747edda7d1deca0bc8372590c1ad6b44a5131e0f"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "ce9f9d510317dfbba0837dd218cdc7efdff7efd9cf77ba2f305ef260241e7a4f"
    sha256                               arm64_monterey: "796698816b1f016bf8104c57b7cd9ee5caa685252d347693a7a747387a998dd5"
    sha256                               arm64_big_sur:  "f31afebc43b08fc1819db4871adf0000ea438b0b6e00d4e43b5ec193aeee70b1"
    sha256                               ventura:        "93e8ce2edd4df8f8f8e3f940868a5e1f989ffd7ab1f7d2b87e4afca83ef50290"
    sha256                               monterey:       "a1861ca5bd9ccb588b4edc69f666f48d97aaf3af0af12054f1e5a2e4142186ab"
    sha256                               big_sur:        "c0a70b6b7dc38d7abacd91c242caa9bb0c06dacbcdbdda1d1581ad4ad95d78ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a6d0bd8c9f5491ef05e7334bc0e5c4527470879fb8a8a0588d5792b6b1f0a74"
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
