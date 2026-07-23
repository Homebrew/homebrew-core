class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-1.0.2.tgz"
  sha256 "bfaf8e18750aa03a79b32fe44886d1b5c88c45d022354b4cebde3d8b0e7594f7"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "92bafa11ed51095158b46bbdc3609b7d810eeb781408f4f4a42d71d12f0c3492"
    sha256 cellar: :any, arm64_sequoia: "58fd1458c712ee878f5670b04d31e39364caea9f3a5e7f3eebe9c0103737c8e9"
    sha256 cellar: :any, arm64_sonoma:  "58fd1458c712ee878f5670b04d31e39364caea9f3a5e7f3eebe9c0103737c8e9"
    sha256 cellar: :any, sonoma:        "720eed189da3b14660a7a700e9448c9e8a702ce65db7f9053c7d991630f4a6db"
    sha256 cellar: :any, arm64_linux:   "80d8fc1595e1cd54a863b5ee881f42bac4456adfb3568cac9e196324ea069363"
    sha256 cellar: :any, x86_64_linux:  "2af26b847d3974834883344fdf6024464d12a5d10e9eb17d0ae541a202200933"
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
