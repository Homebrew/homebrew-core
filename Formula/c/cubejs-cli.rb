class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.10.tgz"
  sha256 "7bb5cca93b6f1ea4613dd2c5dd428b27ab36cf838dcbdf005dcf64a5d98533d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8284395ab80845ec953bcdc5f559ae4d8e5c38cf3dddb13c7e6f1c20c90f30bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8284395ab80845ec953bcdc5f559ae4d8e5c38cf3dddb13c7e6f1c20c90f30bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8284395ab80845ec953bcdc5f559ae4d8e5c38cf3dddb13c7e6f1c20c90f30bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f15dff199afb3cbb8007a989c7240f385ae1a2fe0cbbf92464fb9027caf7f0c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fbc1000fe4fab9513beec59dc8fa09befb6cfbb02838052814d90223dc256fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fbc1000fe4fab9513beec59dc8fa09befb6cfbb02838052814d90223dc256fb"
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
