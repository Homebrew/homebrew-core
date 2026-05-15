class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-0.10.12.tgz"
  sha256 "20441266393f4e5d4fa428f0d46278fab5f8c1b7a30eef9cd24c06d3108f7a01"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d514cda991eedc09a8ad1a30385de489a59222454f311980c604e3b336d396a"
    sha256 cellar: :any,                 arm64_sequoia: "4b2220ef4bb5c7de7e2c664b9bdf3f6cd2bd2eb12be7de0b03be9e88c436ed1a"
    sha256 cellar: :any,                 arm64_sonoma:  "4b2220ef4bb5c7de7e2c664b9bdf3f6cd2bd2eb12be7de0b03be9e88c436ed1a"
    sha256 cellar: :any,                 sonoma:        "8c61deae220390cd84ad54e2540e18c9ef99201ef3805b945fd305225fd46c49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d28033b4e93397f410928a445f7dd85f72c8901a84dd76e2232ea78c751563e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8cbb6dab679388a48266c8a4bf78d887e9787705b705e4fa9741940386da71f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/ovsx verify-pat 2>&1", 1)
    assert_match "Unable to read the namespace's name", error
  end
end
