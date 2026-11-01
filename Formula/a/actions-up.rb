class ActionsUp < Formula
  desc "Tool to update GitHub Actions to latest versions with SHA pinning"
  homepage "https://github.com/azat-io/actions-up"
  url "https://registry.npmjs.org/actions-up/-/actions-up-2.0.0.tgz"
  sha256 "3be5a0eb9b3d91937266acde797050fce971a11f9f6f3a95f26ae882ccac876f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd121770db48ef24bbe161237b9f0bff195928db9e9d8ecb021d9ce339f78e9e"
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
