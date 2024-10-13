class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.36.8.tgz"
  sha256 "ccb44fefab710ac00d334edcfe4b611e66360aaccc1c02705685924eccaf41b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32ba8714a07482d22cbb0d73a84f23bc10b57c9c59059ccc11b1ebccfa697e57"
    sha256 cellar: :any,                 arm64_sonoma:  "32ba8714a07482d22cbb0d73a84f23bc10b57c9c59059ccc11b1ebccfa697e57"
    sha256 cellar: :any,                 arm64_ventura: "32ba8714a07482d22cbb0d73a84f23bc10b57c9c59059ccc11b1ebccfa697e57"
    sha256 cellar: :any,                 sonoma:        "67a90c2b22aa99607463a53c526e879177fdda91f7e38414b0e29c247a8db047"
    sha256 cellar: :any,                 ventura:       "67a90c2b22aa99607463a53c526e879177fdda91f7e38414b0e29c247a8db047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75195c99a130c79b7dc0410eefedb22cee6cf4c447f8ffe669c44a0703483c64"
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
