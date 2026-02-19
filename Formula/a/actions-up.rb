class ActionsUp < Formula
  desc "Tool to update GitHub Actions to latest versions with SHA pinning"
  homepage "https://github.com/azat-io/actions-up"
  url "https://registry.npmjs.org/actions-up/-/actions-up-1.12.0.tgz"
  sha256 "1052cdc96983a6c1948d903e7b0836af91a37b17b9d3ea5dab60585464d90bd3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0e1ba5920cefb2c0c5ac6fabb73564d633924301a207b00ff702644410c6069e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actions-up --version")

    test_file = testpath/".github/workflows/action.yml"
    test_file.write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    assert_match "Updates applied successfully!", shell_output("#{bin}/actions-up --yes")

    assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, test_file.read)
  end
end
