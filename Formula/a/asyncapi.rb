require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.6.16.tgz"
  sha256 "afc558359f1128e7b8ec117b956a5078d2a835a14d688e538b150d188fa9dc6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "59934b4a0c3fc514370557e935a202d70b98dac7287cb0efa2d3a5468480ca9d"
    sha256 cellar: :any,                 arm64_ventura:  "59934b4a0c3fc514370557e935a202d70b98dac7287cb0efa2d3a5468480ca9d"
    sha256 cellar: :any,                 arm64_monterey: "59934b4a0c3fc514370557e935a202d70b98dac7287cb0efa2d3a5468480ca9d"
    sha256 cellar: :any,                 sonoma:         "65b89b8028936e648a97e9988a0c7ece9fe1f0755540a1e48587c5866c00fd51"
    sha256 cellar: :any,                 ventura:        "65b89b8028936e648a97e9988a0c7ece9fe1f0755540a1e48587c5866c00fd51"
    sha256 cellar: :any,                 monterey:       "65b89b8028936e648a97e9988a0c7ece9fe1f0755540a1e48587c5866c00fd51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdd3871544138acb857c8db4aec3969999626b3a1e1a74446dc96b5e3b2df791"
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
