require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.37.0.tgz"
  sha256 "c1ae922fdbbd8a3f7d6ef22d4b423d8877e491d41aba275e8e016cbd7559829f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ebf64aa618500f520545a43d422fbd643257b049bbe351944e1069c132f30168"
    sha256 cellar: :any,                 arm64_monterey: "28f45b85dc3dff1ab0720a68a8b9a21d7c9b597b1a14a6bf389779451897a87c"
    sha256 cellar: :any,                 arm64_big_sur:  "ebf64aa618500f520545a43d422fbd643257b049bbe351944e1069c132f30168"
    sha256 cellar: :any,                 ventura:        "ad531b4e0b41436cd87bd17d7162d6898daab998036ff70928ab82ce20313875"
    sha256 cellar: :any,                 monterey:       "ad531b4e0b41436cd87bd17d7162d6898daab998036ff70928ab82ce20313875"
    sha256 cellar: :any,                 big_sur:        "ad531b4e0b41436cd87bd17d7162d6898daab998036ff70928ab82ce20313875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a9170f3f1b5e8510ebc38eda924ba42badd7374c4429b16ddc84c5fdce1b027"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
