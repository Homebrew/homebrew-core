class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.4.9.tgz"
  sha256 "ab92f9e7bc4413cbd18ef67a7a00eec46912050d95b8fbb9ffc14fd50636cf11"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21261b4db875faaf87b5969ba6ee146dc6475ac647509d587c352446c56a3a5c"
    sha256 cellar: :any,                 arm64_sequoia: "c0f72eba4c4be4142680f0cc229713f29638f3aa680fcb206fe70eaaf135dcd9"
    sha256 cellar: :any,                 arm64_sonoma:  "c0f72eba4c4be4142680f0cc229713f29638f3aa680fcb206fe70eaaf135dcd9"
    sha256 cellar: :any,                 sonoma:        "77c6a9c6f9ad8c292434d9f34b747a689ee53a7e473eae1297fbdc86c0130342"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88ae70a18c1d33197b035ca5c8107ccaa737c57140264997afeca58684fc19ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e924883e4595963f057c85ac5ed8738e23557390b82e107047f5781a05e3f88e"
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
