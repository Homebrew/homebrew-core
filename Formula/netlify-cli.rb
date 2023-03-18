require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  # netlify-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-13.1.5.tgz"
  sha256 "04f4dc7685e7201b461a4480722fd3f6c0d44e91a78428117737af9616d8d278"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "972d982dcbfa5ad5d0aa9c27ab8a4f29ac123288bc81ec1b8c3cf580a46a11a3"
    sha256                               arm64_monterey: "ef472c475743001cb2df2801c6e79ae7be64e0a294b210689e0d8e0bc5137520"
    sha256                               arm64_big_sur:  "c9df334a9c1db696267f433c20555ca5977ceb6b4f1928e42aba52a1b9d0f596"
    sha256                               ventura:        "11eb02db8175d66a30f8c0dfd92929fea5ec492bdbf91e683580147e100d23c3"
    sha256                               monterey:       "503dfe7b8f5dd910dd6bf5b1e22dc7b210a66910cb127b9c36d2ea2a3581da68"
    sha256                               big_sur:        "975330db41b2a0fb5cd71f2e0e6c7de5248607645632936e38c749a979cdd42b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd7fdb780c207a834174fa41ce85bbd9c1364092ba23b5894594ce3f7d470298"
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
