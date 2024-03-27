require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.4.tgz"
  sha256 "6798f56c730a66d30290c9eb1d73432a58ee06eaf2362f273747ed89287ddb7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ef312cf61fa17b5102f8ff696801d3fef314c917c9f3b68115fbd2aa6c00dcd"
    sha256 cellar: :any,                 arm64_ventura:  "8ef312cf61fa17b5102f8ff696801d3fef314c917c9f3b68115fbd2aa6c00dcd"
    sha256 cellar: :any,                 arm64_monterey: "8ef312cf61fa17b5102f8ff696801d3fef314c917c9f3b68115fbd2aa6c00dcd"
    sha256 cellar: :any,                 sonoma:         "863d8f362c7b054760982e92e0a1fae6c7809a68033aab19248dcdab57422b88"
    sha256 cellar: :any,                 ventura:        "863d8f362c7b054760982e92e0a1fae6c7809a68033aab19248dcdab57422b88"
    sha256 cellar: :any,                 monterey:       "863d8f362c7b054760982e92e0a1fae6c7809a68033aab19248dcdab57422b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4719a4a4043da2c8a460d89451828d546fa3fc794f2d72ba826c16500f8c2f57"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
