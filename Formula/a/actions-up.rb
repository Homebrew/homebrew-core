class ActionsUp < Formula
  desc "Tool to update GitHub Actions to latest versions with SHA pinning"
  homepage "https://github.com/azat-io/actions-up"
  url "https://registry.npmjs.org/actions-up/-/actions-up-2.1.0.tgz"
  sha256 "ac7f70a441db85163b7c690e901721894d1a7ce7249d6deaef25fc86be59b3d2"
  license "MIT"

  bottle do
    manifest_sha256 "f75dc3d87432fcd7e624a28faaab57ef8c778ab03c8b34b647bb050033f89677"
    sha256 cellar: :any_skip_relocation, all: "3cba487166123ee1c0a56ec58113367d3571eb6208ec62ce163f0469bf8a41f7"
  end

  depends_on "node"

  deny_network_access! :postinstall

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

    begin
      output = shell_output("#{bin}/actions-up --yes")
    rescue Minitest::Assertion
      # Ignore GitHub API rate limit errors which are common on CI runs
      assert_match "⚠️ Rate Limit Exceeded", shell_output("#{bin}/actions-up --yes 2>&1", 1)
    else
      assert_match "Updates applied successfully!", output
      assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, test_file.read)
    end
  end
end
