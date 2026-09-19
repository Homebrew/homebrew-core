class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.42.tgz"
  sha256 "de30ad7a1fbeedfeb6bb88b70a9d69a481c3203b8ca55d70d281d232ac71bead"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a6f9c479cb6fc0fa9b4791babc69153cf28078aeba5aa0b0578c13a8a47e9a69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6f9c479cb6fc0fa9b4791babc69153cf28078aeba5aa0b0578c13a8a47e9a69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6f9c479cb6fc0fa9b4791babc69153cf28078aeba5aa0b0578c13a8a47e9a69"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "779bb3f3ef7c53e06701f02ec9a1fb8eada0b8550abb6274e08fa90f14b1f202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "779bb3f3ef7c53e06701f02ec9a1fb8eada0b8550abb6274e08fa90f14b1f202"
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
