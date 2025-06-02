class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.18.tgz"
  sha256 "6ebcac97fe6e0dd8b1aa0e340f8c092ec08ceec4489b23b1a64c8a98be6916fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d0a7fed8751e7105d02a93f4367b354bb2decfca12bd755f2062adf10739f141"
    sha256 cellar: :any,                 arm64_sonoma:  "d0a7fed8751e7105d02a93f4367b354bb2decfca12bd755f2062adf10739f141"
    sha256 cellar: :any,                 arm64_ventura: "d0a7fed8751e7105d02a93f4367b354bb2decfca12bd755f2062adf10739f141"
    sha256 cellar: :any,                 sonoma:        "6da9781307a0551f15cd688f922860d29c5ef7fb7e597836b4406c55a4184df0"
    sha256 cellar: :any,                 ventura:       "6da9781307a0551f15cd688f922860d29c5ef7fb7e597836b4406c55a4184df0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4ddb257afedb5a5c278356709c72e435e78adc7da707d3203bd552edd404977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca6148fd18f6593b5179338baa5e965ec552f831523b8f5b61a5acea314d72e8"
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
