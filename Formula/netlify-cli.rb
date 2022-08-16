require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.17.0.tgz"
  sha256 "7e49491ca81a584759d3d8b62c5e49e5934b2abd46f9dc350659b989486900a5"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32773ce0e8355bcea6ce51d47e6db5f1c7602bae7d993d98523396a38aece0f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32773ce0e8355bcea6ce51d47e6db5f1c7602bae7d993d98523396a38aece0f5"
    sha256 cellar: :any_skip_relocation, monterey:       "85533d39a5e9205e3b56eae6359406f1b9fe486b43633334ef3b0e71203f696f"
    sha256 cellar: :any_skip_relocation, big_sur:        "85533d39a5e9205e3b56eae6359406f1b9fe486b43633334ef3b0e71203f696f"
    sha256 cellar: :any_skip_relocation, catalina:       "85533d39a5e9205e3b56eae6359406f1b9fe486b43633334ef3b0e71203f696f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51afdb3b5dc54ae8be177c06c75c9a0c7a0455804988a42f4871afb98eda71b1"
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
