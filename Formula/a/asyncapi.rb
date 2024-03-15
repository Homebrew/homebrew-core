require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.6.14.tgz"
  sha256 "90a4432c54ea25f65fc4b96f76c2ed6f4c9b9e5dc3e90fc89d989d25b8e629cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2c21c30b590ca9bfe1ac966454d4993e8bea3b3cb4f0bd3ac5912e58aa9534a9"
    sha256 cellar: :any,                 arm64_ventura:  "2c21c30b590ca9bfe1ac966454d4993e8bea3b3cb4f0bd3ac5912e58aa9534a9"
    sha256 cellar: :any,                 arm64_monterey: "2c21c30b590ca9bfe1ac966454d4993e8bea3b3cb4f0bd3ac5912e58aa9534a9"
    sha256 cellar: :any,                 sonoma:         "f0057ef4c817b1f154bc2008b0a35d45f51ae5e37189b82c6a3cf351b614dec7"
    sha256 cellar: :any,                 ventura:        "f0057ef4c817b1f154bc2008b0a35d45f51ae5e37189b82c6a3cf351b614dec7"
    sha256 cellar: :any,                 monterey:       "f0057ef4c817b1f154bc2008b0a35d45f51ae5e37189b82c6a3cf351b614dec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac116b37e66aed5b7f368d98f5470bc4b06759eef16cc23201d433fb92c8db6a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
