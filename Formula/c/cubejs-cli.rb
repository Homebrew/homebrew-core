class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.1.tgz"
  sha256 "519969b42e56e628eeb3ee90262b582636271722e76dc554308057fe61a2dcc6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57075761bf42ace226c9ace76c8d4b736ebdfd9b2bd90c6eae605e9417530e7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9411c32512e5f600d5dfa70d1d6a27d2af53ab14151ad68815046a53f64aa6c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9411c32512e5f600d5dfa70d1d6a27d2af53ab14151ad68815046a53f64aa6c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e173e69f9b6820d18fdee20aa514c51afdba6a2e1d1a1aba7ca757e0162fb4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "738af69e59fa734712fa99e33689a9860928bb0daf8c06843b91bf87c0867464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "738af69e59fa734712fa99e33689a9860928bb0daf8c06843b91bf87c0867464"
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
