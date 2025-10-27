class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-4.0.1.tgz"
  sha256 "9079d074972bd0dc952ec9106c9456bec5d69342202c05ef014d09bd4146fcfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "54f6c63aaaa80382a23a8ac0175c56fb50e8fac09d814bf7f419b0442fcfdb19"
    sha256 cellar: :any,                 arm64_sequoia: "3c69361a913ed627ee1e30fe8b259910ad5d269e07838e7ddd7a13cf74c4e04e"
    sha256 cellar: :any,                 arm64_sonoma:  "3c69361a913ed627ee1e30fe8b259910ad5d269e07838e7ddd7a13cf74c4e04e"
    sha256 cellar: :any,                 sonoma:        "3accb0d778a81493955971edd6b9c348fd0c3391a6021d5a415c301e3df39407"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2525fe1a0f9d39739be3285f7743b578c4c2e168a7dd82c5f62711379417ead1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f71407f969f3eef4626760c9d9fedbb38da23884bd8863664fdf17924903246e"
  end

  depends_on "node"

  def install
    system "npm", "install", "--ignore-scripts", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Cleanup .pnpm folder
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    rm_r (node_modules/"@asyncapi/studio/build/standalone/node_modules/.pnpm") if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end
