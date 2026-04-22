class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-0.10.11.tgz"
  sha256 "f5d63bf003f54b435cb1567d80d9b69ad451c86eda608d7fe8ee6ca425362c05"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c5d0c87ccb6c9a6e9e25497629dcd7b5097f80c06ca4f26cecfd97c0926c008"
    sha256 cellar: :any,                 arm64_sequoia: "9e7ca68c7cd13568e2849b854b124aa2bdf1805d511be6616d0763eb03e6d792"
    sha256 cellar: :any,                 arm64_sonoma:  "9e7ca68c7cd13568e2849b854b124aa2bdf1805d511be6616d0763eb03e6d792"
    sha256 cellar: :any,                 sonoma:        "fd45c88d31b34291a45ceea8995f2349b4a195fe4487fa2290c7fa3f1a8e8084"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5172d488415babcdbcf9469634fb120bff3f13c5d981e1fe9e442a44113b5387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7a2abc2343c5edda5e0dc45c766ee654a460ad49f36796109b84119f33a99e6"
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
