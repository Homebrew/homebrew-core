class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.23.0.tgz"
  sha256 "fafbf07ef258b24c2d1bfd8fba42d9306c31761f7ee3c910e298ca23b5cacb70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1ce51cd86b9bc57013c767cbccb8cc61085e51d788231212a9454973f7f38445"
    sha256 cellar: :any,                 arm64_sequoia: "267ecf9cc883074de9f2a0c9b970627a7688c5e81a1929a2ad19f3c99727e313"
    sha256 cellar: :any,                 arm64_sonoma:  "267ecf9cc883074de9f2a0c9b970627a7688c5e81a1929a2ad19f3c99727e313"
    sha256 cellar: :any,                 sonoma:        "b0b4af381716acebc19ba2cfe854d789ae6af70ed02a8d06a0d7637bfb496b05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af638b03ec38ebcb269c406e9bf4ad749c245bff7f2d58b6070bc075517fa294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a85e193d9a98f7c3bdb901eab8894834b0dafbf879cbfcc86890b916b0eb97"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
