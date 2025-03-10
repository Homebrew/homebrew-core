class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.16.8.tgz"
  sha256 "6e70d5dfe0edf4726e869ed42ae59047fc958517001d41af32f7dcc088e8ddfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1e5906545467115f4a3c4433bb1edb5c5a3a809820b0b729d7564034a76b8b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1e5906545467115f4a3c4433bb1edb5c5a3a809820b0b729d7564034a76b8b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1e5906545467115f4a3c4433bb1edb5c5a3a809820b0b729d7564034a76b8b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dc4ed64496568f8250238ef211e05ead02af9b4721a991c3bdfdbf1ab58e84b"
    sha256 cellar: :any_skip_relocation, ventura:       "2dc4ed64496568f8250238ef211e05ead02af9b4721a991c3bdfdbf1ab58e84b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1e5906545467115f4a3c4433bb1edb5c5a3a809820b0b729d7564034a76b8b1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end
