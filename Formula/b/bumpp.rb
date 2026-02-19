class Bumpp < Formula
  desc "Interactive CLI that bumps your version numbers and more"
  homepage "https://github.com/antfu-collective/bumpp"
  url "https://registry.npmjs.org/bumpp/-/bumpp-10.4.1.tgz"
  sha256 "373b62e7841ba156fba34372b0b35e0bc481c1ded0f055f45b9bd2efaad00e93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "038a8786c1a4b8f745cc1ce4cb2177bba508e40e6151d8725a2b5b7e12b26c66"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bumpp --version")
    system "git", "init"
    (testpath/"package.json").write <<~JSON
      {
        "name": "bumpp-homebrew-test",
        "version": "1.0.0"
      }
    JSON

    system "git", "add", "package.json"
    system "git", "commit", "-m", "Initial commit"

    system bin/"bumpp", "--yes", "--push", "false", "--no-commit", "--release", "patch"

    package_json = (testpath/"package.json").read
    package_hash = JSON.parse(package_json)
    assert_match "1.0.1", package_hash["version"]
  end
end
