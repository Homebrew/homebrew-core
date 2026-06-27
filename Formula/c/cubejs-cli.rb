class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.64.tgz"
  sha256 "99e477715a59fe36db69475cdcca0bffc767be6ac6f9e5f970cf31ee30e32a5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6879f974eea0d325ff567d3382768325a9f0ef82defb3a1a7d86cd063617b462"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3d41ed6f34dba03a650ee648047b017806c4d6dc0ef97801aa31b8f409e351c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3d41ed6f34dba03a650ee648047b017806c4d6dc0ef97801aa31b8f409e351c"
    sha256 cellar: :any_skip_relocation, sonoma:        "886e84f6f6de3c02b58d0de3ce0bcf96ae7b269246d6e135b79d79fe5ce18933"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d11bd75032c8b635baf225a53c7642c484da5701c5b7a8ecdb49af7bb4702ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d11bd75032c8b635baf225a53c7642c484da5701c5b7a8ecdb49af7bb4702ad7"
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
