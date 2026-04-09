class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.32.tgz"
  sha256 "e2e5d0d37b74b2efd2fa7ff6a34f7e8c0516aa162c07e820dd7afacf48d9fb0a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87c4c5369e15303b9b17fabf9383d4a99756f03c1b6f2bef94a2320aa53d36f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab236cdc66bdf60dda3cdd355c983160f412e164b6221d6167b49134ab2ef338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab236cdc66bdf60dda3cdd355c983160f412e164b6221d6167b49134ab2ef338"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f995fbcb49381a4eed0957d245f6e29aaabcadfa8750e2e91f84b64fda02fb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6b77a3054dce41e18da3167a1fd3cc3d57d0f34a50d6e904b99f41521d0e4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6b77a3054dce41e18da3167a1fd3cc3d57d0f34a50d6e904b99f41521d0e4cc"
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
