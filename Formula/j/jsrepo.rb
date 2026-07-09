class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.8.0.tgz"
  sha256 "26f92406c8b78292f64b625c56f5975d489fb828d8630b911f593cbde39683e7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a94ab660d761e17f36e0a682c7722d925e7e59f57d7dd65b0ba8ec50d98cc6d"
    sha256 cellar: :any,                 arm64_sequoia: "1da67b31ebda86db8b4edb872f2582064fa423f975ed54ed369e6c5ea3edb401"
    sha256 cellar: :any,                 arm64_sonoma:  "1da67b31ebda86db8b4edb872f2582064fa423f975ed54ed369e6c5ea3edb401"
    sha256 cellar: :any,                 sonoma:        "0d9be6230acf1ff1b784e85add44aafc807069a4882a74fee56db3442a9fc17e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "402efb13e7ba3d1db23a4af5dc7673f2254387c7074e398fd5947869a4c1dfd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133d7b665d25c5e29db6bb356f0059d1fad864d91982e962e3c6c9af64ddb642"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end
