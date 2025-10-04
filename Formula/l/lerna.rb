class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-9.0.0.tgz"
  sha256 "7109aa9fb78786f335a2a9b555a5bf4d32658d8f56436f380e6fb35e8276e2b0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3acc7832dae9a9d6e099f357f0dcc11fbb122b2ecb511564d93ba9ef7dfbc5fb"
    sha256 cellar: :any,                 arm64_sequoia: "36e2bbd1e7653510262723aa31cb32f5cd2410e30de70f06fc4ae6dc8a014416"
    sha256 cellar: :any,                 arm64_sonoma:  "36e2bbd1e7653510262723aa31cb32f5cd2410e30de70f06fc4ae6dc8a014416"
    sha256 cellar: :any,                 sonoma:        "8b33bf221d2a9a989293f79013ee39c8ff5175124f718a754f3ffe2f12cb9822"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1aeaaaa7fc55cbfb5f2e1a5f7bc62f18b962c46c902e4384471e1d07f7ae087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b017765bc6e29242227d85c048285bd27d0a87d4386e5a029001072f13c14b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
