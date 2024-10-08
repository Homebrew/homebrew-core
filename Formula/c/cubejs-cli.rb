class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.36.7.tgz"
  sha256 "a4a79941e368ff08166dab66d700f897126fc2e0c2ff7bf7198469fbdc3766f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d208ba0e0fd5c93753ba494859c4a1cbdfc513e5d94fc6578d5d8334f7ffdfb9"
    sha256 cellar: :any,                 arm64_sonoma:  "d208ba0e0fd5c93753ba494859c4a1cbdfc513e5d94fc6578d5d8334f7ffdfb9"
    sha256 cellar: :any,                 arm64_ventura: "d208ba0e0fd5c93753ba494859c4a1cbdfc513e5d94fc6578d5d8334f7ffdfb9"
    sha256 cellar: :any,                 sonoma:        "44cad781f63b1ee83094e3cb181c4de3990d501a137243f726349a91ad0d3549"
    sha256 cellar: :any,                 ventura:       "44cad781f63b1ee83094e3cb181c4de3990d501a137243f726349a91ad0d3549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9f60ec89b89e69fc6271f77c03257fc6a2e4335a1f4da7f67e9992e441c91f5"
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
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
