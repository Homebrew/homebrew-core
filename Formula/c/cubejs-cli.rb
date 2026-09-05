class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.31.tgz"
  sha256 "065b8e56d16f3777733e95d3ac92fc63abfaf2fbabceb9b7afbb6dc7b5b3f50d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e60b353545a9974fbdb1f40d95ac200032a19b202b5278f7b6d74f3af0cd575"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e60b353545a9974fbdb1f40d95ac200032a19b202b5278f7b6d74f3af0cd575"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e60b353545a9974fbdb1f40d95ac200032a19b202b5278f7b6d74f3af0cd575"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "827d76d654a954d721fed0dc28dd09bd0aefc55dc73f8b991a3f960cbb45fe83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "827d76d654a954d721fed0dc28dd09bd0aefc55dc73f8b991a3f960cbb45fe83"
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
