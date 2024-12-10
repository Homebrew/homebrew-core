class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.12.1.tgz"
  sha256 "9d22fa5b378a65ea3a1aeb6d8b45b63b64d728c97fc9e2ca0bd11a440b40beb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5523485d191fa6948c2fc26daa909b6d83f72973a90c64020a5652c874152a69"
    sha256 cellar: :any,                 arm64_sonoma:  "5523485d191fa6948c2fc26daa909b6d83f72973a90c64020a5652c874152a69"
    sha256 cellar: :any,                 arm64_ventura: "5523485d191fa6948c2fc26daa909b6d83f72973a90c64020a5652c874152a69"
    sha256 cellar: :any,                 sonoma:        "4231c14d098b22bf2b70e58975104ffcc9e6b981e78f976cd315b391b7916e0a"
    sha256 cellar: :any,                 ventura:       "4231c14d098b22bf2b70e58975104ffcc9e6b981e78f976cd315b391b7916e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e852ce83aa2411afbfa2f811e03a50f3d352ae9229be48c3c5f8e81050aa2931"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
