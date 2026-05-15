class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.46.tgz"
  sha256 "a21660867867de074e28ee211ec7880150940d5789160997ec50d7eb434cd2e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5938d01f801696db467fa1629e13bc9c57414f159301c345af0f484c78f4ca2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaf15641363edb50d10635aeaaff71b10a93215292a10e345c104161cfc5d565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaf15641363edb50d10635aeaaff71b10a93215292a10e345c104161cfc5d565"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c54442b8b4d0fdb5658708c4823c429d5859a4a705d77ebe46b3c9e9b275d84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e0883d4310383acd41f6aa4b1f47c29b49bf31e175ca8e02d2ca5435f195794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e0883d4310383acd41f6aa4b1f47c29b49bf31e175ca8e02d2ca5435f195794"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
