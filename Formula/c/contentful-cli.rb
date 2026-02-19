class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.10.3.tgz"
  sha256 "4772c7ecc9a39268a1dbf1c771382cc77609b6b0ffd3372ff636869d72595b09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fac9bf283bd40fc26016943d6966d364ee1be4f433bc973b0c0b800e163a2337"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fac9bf283bd40fc26016943d6966d364ee1be4f433bc973b0c0b800e163a2337"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fac9bf283bd40fc26016943d6966d364ee1be4f433bc973b0c0b800e163a2337"
    sha256 cellar: :any_skip_relocation, sonoma:        "fac9bf283bd40fc26016943d6966d364ee1be4f433bc973b0c0b800e163a2337"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fac9bf283bd40fc26016943d6966d364ee1be4f433bc973b0c0b800e163a2337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "890c1e3e39e1cb6ce831130394a43ba403960ba82f2cca4c543f462c94645912"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
