class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.16.tgz"
  sha256 "2b4011245c7458566343340b7e9fe4860b44f50bae0a7fa9d3e5043c0a43c45d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7ebedcfdc8ba24e6b99d7f257f4f11d9fad11ddfd379e5b8731baba5116b90c5"
    sha256 cellar: :any,                 arm64_sonoma:  "7ebedcfdc8ba24e6b99d7f257f4f11d9fad11ddfd379e5b8731baba5116b90c5"
    sha256 cellar: :any,                 arm64_ventura: "7ebedcfdc8ba24e6b99d7f257f4f11d9fad11ddfd379e5b8731baba5116b90c5"
    sha256 cellar: :any,                 sonoma:        "fc041363ca77ad70a1fa66f8c94b1d04f96ad41cd9edf1a06f042439f15347a7"
    sha256 cellar: :any,                 ventura:       "fc041363ca77ad70a1fa66f8c94b1d04f96ad41cd9edf1a06f042439f15347a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d5d0ed4ffedc98078395c6e0e81fdfc6983549cffc42d1e60dc466ac29c407d"
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
