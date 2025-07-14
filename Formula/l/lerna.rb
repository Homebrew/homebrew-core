class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.2.3.tgz"
  sha256 "7bf700d313ce27e7c1608b2fa8c582a7447c7144f090a9280fb484efe4afcab2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "795ab926596134bd1966bec74f90cf772dc96c70aeedacafbe567d3a68294031"
    sha256 cellar: :any,                 arm64_sonoma:  "795ab926596134bd1966bec74f90cf772dc96c70aeedacafbe567d3a68294031"
    sha256 cellar: :any,                 arm64_ventura: "795ab926596134bd1966bec74f90cf772dc96c70aeedacafbe567d3a68294031"
    sha256 cellar: :any,                 sonoma:        "4849e734553e3a1badb238f62153bc334df093fdb2b6eb3a194710e9d1f7e06e"
    sha256 cellar: :any,                 ventura:       "4849e734553e3a1badb238f62153bc334df093fdb2b6eb3a194710e9d1f7e06e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a2bc86ea7eda564c7acdecb27ed7c1f3683bd73dadd96309ecb7fddfcb4d7f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ee357e82763fe37de4e21b27cb76f9685d3faa9f22cb23d97e530587e193e75"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
