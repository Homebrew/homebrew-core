require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.8.0.tgz"
  sha256 "5f958e33eeda74fef3d1a17a694f8012c2eb1cadcda735135376d4ef9bccd765"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "a1faeaaf01dd107c044e2cfb83b69abfd58c69b108c9b5bfa7bb6e2183f3b8c5"
    sha256                               arm64_ventura:  "c1b71c9cf94062383c33a65bf08e006a6cbac52ff1f2637629417f2c8b56e8a3"
    sha256                               arm64_monterey: "794d7be0b7a28c4c1075d35062c95c9b89d6638a029b9f722b11d6da12dbd850"
    sha256                               sonoma:         "6d17afc268b0736571417af1780f295ecf810c30e5031c6cca5700aba3c298fd"
    sha256                               ventura:        "7a4f435e1ee66fe08494ac89585ed544a3a4f83622cb29018eec8e8ee008ea90"
    sha256                               monterey:       "dcb6b2d8fc2d3d63c885366e96c552d472c2f6da98c9d584d7cfea85d503ef6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f22ad1f9b67fed48a58ee75cbb428c62afc5261d7ae0e3f76e4a426039c471d"
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
