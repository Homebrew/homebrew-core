class Bumpp < Formula
  desc "Interactive CLI that bumps your version numbers and more"
  homepage "https://github.com/antfu-collective/bumpp"
  url "https://registry.npmjs.org/bumpp/-/bumpp-12.0.0.tgz"
  sha256 "dadc3864096183e287209c0f3658eda6044e9273892b23ec3a1f77ad05357157"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83087780310bee0e82d8ab6dd47c670b56668f7689b76e7da18cd100a76de146"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bumpp --version")

    mkdir "repo" do
      system "git", "init"
      (testpath/"repo/package.json").write <<~JSON
        {
          "name": "bumpp-homebrew-test",
          "version": "1.0.0"
        }
      JSON

      system "git", "add", "package.json"
      system "git", "commit", "-m", "Initial commit"

      system bin/"bumpp", "--yes", "--push", "false", "--no-commit", "--release", "patch"

      package_json = (testpath/"repo/package.json").read
      package_hash = JSON.parse(package_json)
      assert_match "1.0.1", package_hash["version"]
    end
  end
end
