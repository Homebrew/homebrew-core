class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.39.2.tgz"
  sha256 "853f7d7c3ce103a1f6bc5613ec82d5c48f25573ca2b73ac1ab297fa4ade8df61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "860bf9af54b00aaaed4477a906448ce1dd7feeb8cf28a5f8a1ba3fa055dc03fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "860bf9af54b00aaaed4477a906448ce1dd7feeb8cf28a5f8a1ba3fa055dc03fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "860bf9af54b00aaaed4477a906448ce1dd7feeb8cf28a5f8a1ba3fa055dc03fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "34d2dc6ab1b6c116020e2bcce49da5b638b47c6332ffe163d95d37b229aab7ff"
    sha256 cellar: :any_skip_relocation, ventura:       "34d2dc6ab1b6c116020e2bcce49da5b638b47c6332ffe163d95d37b229aab7ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63975160ae7bf42c2778d90630de37f4ea0a27d2f19739714bb48e07b0e1f84d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end
