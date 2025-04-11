class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.47.0.tgz"
  sha256 "6948f63b12a26877afeac1bcb12a3613f8742b0b70dcdb4c19c21618b7661a18"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b464b7482e2f282bd4f016cc7e49b5503890708f8035ea505d269eeabda141a6"
    sha256 cellar: :any,                 arm64_sonoma:  "b464b7482e2f282bd4f016cc7e49b5503890708f8035ea505d269eeabda141a6"
    sha256 cellar: :any,                 arm64_ventura: "b464b7482e2f282bd4f016cc7e49b5503890708f8035ea505d269eeabda141a6"
    sha256 cellar: :any,                 sonoma:        "5fb180c022ad4bb03385c8e8f8a02adbdaf48432a260742903b8f1cfbfb6f78a"
    sha256 cellar: :any,                 ventura:       "5fb180c022ad4bb03385c8e8f8a02adbdaf48432a260742903b8f1cfbfb6f78a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbe430a376a98b676b4cf4b390bc6e97682de4d468928e8ddf2a2d66744251fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9585c6f2aed0ba6c873fdb85149b2b8816e06a75efb525649aaa8b2b0d97522"
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
