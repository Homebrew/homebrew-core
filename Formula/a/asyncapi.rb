require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.6.3.tgz"
  sha256 "f4298c5118c3148972b6ebc654af36cf5c375bcf40db167f58cb0ee92f4f082a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ecbb7c9a50fdf6bfa242f41ded066a8681b451c9f034fef73742c5159132e89c"
    sha256 cellar: :any,                 arm64_ventura:  "ecbb7c9a50fdf6bfa242f41ded066a8681b451c9f034fef73742c5159132e89c"
    sha256 cellar: :any,                 arm64_monterey: "ecbb7c9a50fdf6bfa242f41ded066a8681b451c9f034fef73742c5159132e89c"
    sha256 cellar: :any,                 sonoma:         "64657ebda2e2fd71fc36be649ad4f6ff37b89b3844c7b438a1d7f22bf7749006"
    sha256 cellar: :any,                 ventura:        "64657ebda2e2fd71fc36be649ad4f6ff37b89b3844c7b438a1d7f22bf7749006"
    sha256 cellar: :any,                 monterey:       "64657ebda2e2fd71fc36be649ad4f6ff37b89b3844c7b438a1d7f22bf7749006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "416612ca5265d8def412d08f0b4bb9eabe5c185bcbf4d77ebbaa11bb624b203d"
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
