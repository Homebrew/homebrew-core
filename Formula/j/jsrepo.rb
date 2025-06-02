class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.3.3.tgz"
  sha256 "39cdc94cb5fed8f1e6e739256ae0981fadc49e52f401f117ac6490635badd1d6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a37a6286dee4f144566c4de52d1de41e702d9a04ddbbda15d7e2088f778fdf1"
    sha256 cellar: :any,                 arm64_sonoma:  "2a37a6286dee4f144566c4de52d1de41e702d9a04ddbbda15d7e2088f778fdf1"
    sha256 cellar: :any,                 arm64_ventura: "2a37a6286dee4f144566c4de52d1de41e702d9a04ddbbda15d7e2088f778fdf1"
    sha256 cellar: :any,                 sonoma:        "44aa9e637a9d76bfe6dddc26fae96854103353132a4673cfe6489706cae474fc"
    sha256 cellar: :any,                 ventura:       "44aa9e637a9d76bfe6dddc26fae96854103353132a4673cfe6489706cae474fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52b252387c8bf0c9b7b1828a83d727b20598e2fee6bec2c51365c927d8b5cc41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cee79502c54dee936b65c3a0a875238d551317b1c4fe4672de7756a7ea5ac4b"
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
