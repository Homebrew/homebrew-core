class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.36.tgz"
  sha256 "34b687571794e56cad6b6c2cc8d0b7c80785b2133d6a83429ceb0c62a9e39fbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "470480147fbcfe1c0f4184d77dfd1088d304c699199e5cef60d852bfb7c8fd0c"
    sha256 cellar: :any,                 arm64_sonoma:  "470480147fbcfe1c0f4184d77dfd1088d304c699199e5cef60d852bfb7c8fd0c"
    sha256 cellar: :any,                 arm64_ventura: "470480147fbcfe1c0f4184d77dfd1088d304c699199e5cef60d852bfb7c8fd0c"
    sha256 cellar: :any,                 sonoma:        "1f1d01491034266126d716d13a0f26a98324337c49d6488b4828984a79bdb2cd"
    sha256 cellar: :any,                 ventura:       "1f1d01491034266126d716d13a0f26a98324337c49d6488b4828984a79bdb2cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0445ad9ef4a57df452747244336557fe1244301dcceac68e4e6aa0ba7953b5ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb81c425f0d7665dcb3a623f95c0ee8bdeaa9ea77189fcca1388d51cc3ec3ae8"
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
