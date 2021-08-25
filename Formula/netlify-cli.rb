require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.7.5.tgz"
  sha256 "62c6e1f7e0f543a92ec188ba9188e8f1ea2737581ee4b0a24cbc257092ceda94"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5f77d046415644e604b687b0974056e7b4244139c19145113c1fe7765f252f68"
    sha256 cellar: :any_skip_relocation, big_sur:       "712a7ae0194dc167a7dfd96363a7b78481a1abb2e4d4da1bf464983f17f869e2"
    sha256 cellar: :any_skip_relocation, mojave:        "712a7ae0194dc167a7dfd96363a7b78481a1abb2e4d4da1bf464983f17f869e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ece12f7ce13581f4947ae9978c8cf7dbf0bbe5bf9ebf4169bd4ffae5f9722d1"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
