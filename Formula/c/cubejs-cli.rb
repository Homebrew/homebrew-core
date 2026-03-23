class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.26.tgz"
  sha256 "0ee471dc02bd2fb6d2d63b684450aac2d858860bb8b84ea807c9fedc8ac9ed15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77dadef7aa6bdcda0ae1c4901285a11f89a2c934bf029e09d4c9272eb88c6600"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8560bb5d87dbadc7c2eddbbc9fb6bb8f513259af78c49e7711c0b15c9836531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8560bb5d87dbadc7c2eddbbc9fb6bb8f513259af78c49e7711c0b15c9836531"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cbfc33b83744f812355d13266dc41d8f0bcb1cf8f9e4bc91d1d594585b952c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "907864a58d0cc087aa060618d04d080e6b30a5e61f689f06e198a06b8a3039c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "907864a58d0cc087aa060618d04d080e6b30a5e61f689f06e198a06b8a3039c7"
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
