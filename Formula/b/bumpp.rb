class Bumpp < Formula
  desc "Interactive CLI that bumps your version numbers and more"
  homepage "https://github.com/antfu-collective/bumpp"
  url "https://registry.npmjs.org/bumpp/-/bumpp-10.4.0.tgz"
  sha256 "627803fdacf42f97eef8a45bff480cfcd7914535a5b008d6c16cf8fab1972da7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c6e54b8d38e2ffea2b7408b76d05a737143d480b7fa61bd82b12f37c047a58d8"
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
