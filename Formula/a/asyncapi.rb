class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.7.1.tgz"
  sha256 "fe4aad548036013545ab97d6676e626f7a694185cfdf1559627e1dc1acb6b87e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e9353070dfb84df2506cfd77bd506fcaef294798f718a888c9ac35c33051335d"
    sha256 cellar: :any,                 arm64_sonoma:  "e9353070dfb84df2506cfd77bd506fcaef294798f718a888c9ac35c33051335d"
    sha256 cellar: :any,                 arm64_ventura: "e9353070dfb84df2506cfd77bd506fcaef294798f718a888c9ac35c33051335d"
    sha256 cellar: :any,                 sonoma:        "cb82d344631809457e6072cdccfd7a4e122dac7686d09f6c05fe593605222cf1"
    sha256 cellar: :any,                 ventura:       "cb82d344631809457e6072cdccfd7a4e122dac7686d09f6c05fe593605222cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fa200e07b52793a9b8ad4e17b550583dc5983aef658dfebf0c828e5f54b2c37"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
