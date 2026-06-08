class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.55.tgz"
  sha256 "a1752fab08da2beaa179beceeb2f05274e990174486e4b3dab8ac54da740b50d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "936075dc796ef48655d6158f777a4468e84d5c9e2f55e2ec6d488d549d6a04d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c86e3106533655fa65368b71f4ff97203f35c6a1664f1d3051ed7c5f944f8ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c86e3106533655fa65368b71f4ff97203f35c6a1664f1d3051ed7c5f944f8ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "8410fe62871abd22d8e0bb499af5a9f5a0dda5c99e31abba4f25b6e2a2d8a6ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "762980932a1a9879b6e2e43e64723beda937c090604c0ccb5090f70f472170da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "762980932a1a9879b6e2e43e64723beda937c090604c0ccb5090f70f472170da"
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
