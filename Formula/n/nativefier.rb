class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-52.0.0.tgz"
  sha256 "483c4fc8e941d5f870c610150f61835ff92ee313688bd3262cf3dca6fb910876"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8217c3f9582943a6a195dff3efcd428a54028e108693ecb6e361e38f8cda83ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8b34ad78186093473325fd42ce2ba129f7a112a7b1d1b978bcc016a643ae1d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8b34ad78186093473325fd42ce2ba129f7a112a7b1d1b978bcc016a643ae1d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8b34ad78186093473325fd42ce2ba129f7a112a7b1d1b978bcc016a643ae1d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4148739ce73c42af24207638a6ebf6a7d1821421b8566218e865509f1891b09e"
    sha256 cellar: :any_skip_relocation, ventura:        "4148739ce73c42af24207638a6ebf6a7d1821421b8566218e865509f1891b09e"
    sha256 cellar: :any_skip_relocation, monterey:       "4148739ce73c42af24207638a6ebf6a7d1821421b8566218e865509f1891b09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f12e3086887b5424fc4a6b718a323f2bc207069ebb4a9419f35680e8ef82fdd"
  end

  disable! date: "2025-01-06", because: :repo_archived

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
