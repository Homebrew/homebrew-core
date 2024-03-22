require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.3.tgz"
  sha256 "34d7e0ef89ada960978ef6ecfcbb6c5a8988a3b873fbf5181860de8f9b490f89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d27e449b7756f57916ac3421c38252b84103004c74e94965bd122fa5c4ac6764"
    sha256 cellar: :any,                 arm64_ventura:  "d27e449b7756f57916ac3421c38252b84103004c74e94965bd122fa5c4ac6764"
    sha256 cellar: :any,                 arm64_monterey: "d27e449b7756f57916ac3421c38252b84103004c74e94965bd122fa5c4ac6764"
    sha256 cellar: :any,                 sonoma:         "8b0a35602a14d4c7f8adb40a3843292fc9f9e7692fbfe8c3bc3a11b899ca7834"
    sha256 cellar: :any,                 ventura:        "8b0a35602a14d4c7f8adb40a3843292fc9f9e7692fbfe8c3bc3a11b899ca7834"
    sha256 cellar: :any,                 monterey:       "8b0a35602a14d4c7f8adb40a3843292fc9f9e7692fbfe8c3bc3a11b899ca7834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59b9489412a22dcbe41f57189823425f6f0f39a61b27ba14b787a2403ec7c50e"
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
