class Qnm < Formula
  desc "CLI for querying the node_modules directory"
  homepage "https://github.com/ranyitz/qnm"
  url "https://registry.npmjs.org/qnm/-/qnm-2.10.4.tgz"
  sha256 "205044b4bbc4637917ac55f936c17b2763e622040cfa84acb1a0289b50b21098"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5cc808b7443c54ea3ef60687da80c4f7845ac3bae1f7fa3aabb211eff6b5ee9e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Build an `:all` bottle
    inreplace libexec/"lib/node_modules/qnm/dist/xdg-open", "/usr/local", HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qnm --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "version": "0.0.1",
        "dependencies": {
          "lodash": "^4.17.21"
        }
      }
    JSON

    # Simulate a node_modules directory with lodash to avoid `npm install`
    (testpath/"node_modules/lodash/package.json").write <<~JSON
      {
        "name": "lodash",
        "version": "4.17.21"
      }
    JSON

    # Disable remote fetch with `--no-remote`
    output = shell_output("#{bin}/qnm --no-remote lodash")
    assert_match "lodash", output
  end
end
