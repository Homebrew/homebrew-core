class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.2.2.tgz"
  sha256 "92412a5122008cfa811d53b1a12d5c35445800ad9537c0227ed17fc6336caa8a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ea39248d03d000d57165e3879a00ae1dcb6fc8617210fa44d9e177358027a4bc"
    sha256 cellar: :any,                 arm64_sonoma:  "ea39248d03d000d57165e3879a00ae1dcb6fc8617210fa44d9e177358027a4bc"
    sha256 cellar: :any,                 arm64_ventura: "ea39248d03d000d57165e3879a00ae1dcb6fc8617210fa44d9e177358027a4bc"
    sha256 cellar: :any,                 sonoma:        "eabd4097f10cbb4ac97c2716d1e9ef044f4b31873685d3b5f12fbd2c1aeaed9e"
    sha256 cellar: :any,                 ventura:       "eabd4097f10cbb4ac97c2716d1e9ef044f4b31873685d3b5f12fbd2c1aeaed9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59c69e98e03fbc56a220bda1e14ab2a20ba27e80d8c85418a7eead84005b709c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4848224c3a5fe8df2069b2e329fb0f76793ba3e100c01361bfb092ccff0a2e29"
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
