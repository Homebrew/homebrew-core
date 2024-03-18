require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.6.16.tgz"
  sha256 "afc558359f1128e7b8ec117b956a5078d2a835a14d688e538b150d188fa9dc6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8f3e51f9f9d0138c41f5acce0ae51301b27c8ead4dc11eab28c9ad2ecbe4d45"
    sha256 cellar: :any,                 arm64_ventura:  "a8f3e51f9f9d0138c41f5acce0ae51301b27c8ead4dc11eab28c9ad2ecbe4d45"
    sha256 cellar: :any,                 arm64_monterey: "a8f3e51f9f9d0138c41f5acce0ae51301b27c8ead4dc11eab28c9ad2ecbe4d45"
    sha256 cellar: :any,                 sonoma:         "dad8d78a0071580e5a54d2d92528c70fe0f75e8d850cef5c7b938553729be05b"
    sha256 cellar: :any,                 ventura:        "dad8d78a0071580e5a54d2d92528c70fe0f75e8d850cef5c7b938553729be05b"
    sha256 cellar: :any,                 monterey:       "dad8d78a0071580e5a54d2d92528c70fe0f75e8d850cef5c7b938553729be05b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cec586dff68e6774a1b7adc097f4f4436684615e5b4706d4ce07adb23448435a"
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
