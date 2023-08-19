require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.1.0.tgz"
  sha256 "9d9313df723039e0795386c0f69ac457a45ab2aadd1d094142e35883a829db2d"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "c01cb17fe69f11dd8b035c78db1e021215b41bc3f344578bf0936609b3e276a3"
    sha256                               arm64_monterey: "d6439d03d7d8bf4ee762df47395ce560169d42b94ec56219ad648bbeebcd754d"
    sha256                               arm64_big_sur:  "75131cc3fd64412606fcdcbb89d8a952f215aa78be71a16635a12c633af08b3a"
    sha256                               ventura:        "57279abbef95f418983afdedb702076f91a6eaa8c994e47646a7dc51eb233a35"
    sha256                               monterey:       "30c4d997546e8d78f1743db08a9a526117b1565d69f2929360fcfd35772d611d"
    sha256                               big_sur:        "a73b9f0868bba6ca131bcf7b2d71dcfa20c938ee5c18fe376aa164de7a7414ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183457bbfe0cfcef889b4481cdb553cf76eb13041528f4fdece31130c0662511"
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
