require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.27.0.tgz"
  sha256 "55f9487c7f07f683bf05b887c8af791907fdc77248578b562d8edae948c02e64"

  bottle do
    sha256 "7b3d37729b309c2983215307ae4e63083c5f5dbd6d649d9fcda31b8df31c1796" => :catalina
    sha256 "bc8bde3e32b41be3a0be3ec53fca5f6945e1b08ac755088a8a0da7b851de090f" => :mojave
    sha256 "91d5d9b9cb09636351e9abb95e8e3b044be1b7c66778ffb837ce576084684588" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
    assert_match "Logging in to balena-cloud.com", output
  end
end
