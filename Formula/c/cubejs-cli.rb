class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.0.tgz"
  sha256 "dbbb0c8d9f6df7fa711396d8d59f4b611d540ee6331d87b2a4f95f43c3978542"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f30ebe56b136cf2912f2952d7f721ce31e3875425280b834a06cb6483297c54e"
    sha256 cellar: :any,                 arm64_sonoma:  "f30ebe56b136cf2912f2952d7f721ce31e3875425280b834a06cb6483297c54e"
    sha256 cellar: :any,                 arm64_ventura: "f30ebe56b136cf2912f2952d7f721ce31e3875425280b834a06cb6483297c54e"
    sha256 cellar: :any,                 sonoma:        "9dde064bdb742e0cb78633cc4baddca6ab299b79f989f5132e512aa9b559e8c6"
    sha256 cellar: :any,                 ventura:       "9dde064bdb742e0cb78633cc4baddca6ab299b79f989f5132e512aa9b559e8c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c49cbd799609c3a5c28f8682bf2221bc24a169060e46081caa26624c26a1b1db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fe20430043fb1d8b2a0106a0fad9ddda8fb89dcdf4b5da48a8754de2d2da9a5"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
