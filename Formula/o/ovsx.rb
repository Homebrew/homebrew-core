class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-0.10.8.tgz"
  sha256 "eb5f4d5d2812d27759abea3d79ba3ee79a9ed6af0dbf12b446b87d74029bf7cb"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ad8529b476195ca06b25a023c3a31fcf7be71906ee2a51a3d74a53d1392b06c"
    sha256 cellar: :any,                 arm64_sequoia: "790a326dc46eac796a9b60a73d749d3e3f7c264fff1d7c6a88d640df620223b5"
    sha256 cellar: :any,                 arm64_sonoma:  "790a326dc46eac796a9b60a73d749d3e3f7c264fff1d7c6a88d640df620223b5"
    sha256 cellar: :any,                 sonoma:        "f44724cdbb32e921450d2c709ebca2ce79d20ca8381b85c57225d7edad232437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02cb4d0acb339f5a0a07162e68bc50d1527473770c581f0efa90953bc91a81e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "202635305a80be66d8f70b9a1226e76e035870829699f466500d0c15be99daff"
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
