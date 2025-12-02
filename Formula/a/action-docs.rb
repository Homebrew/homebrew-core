class ActionDocs < Formula
  desc "Generate docs for GitHub actions"
  homepage "https://github.com/npalm/action-docs"
  url "https://registry.npmjs.org/action-docs/-/action-docs-2.5.1.tgz"
  sha256 "f7d93433a6d3e532b30b3fc068fa263d16f7c38da91422450507b469bd36a64a"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "89a129206e1fd2a3bb48e3f7923ba2bbb98c3533d28332c2511c6ff093807f51"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_file = testpath/"action.yml"
    test_file.write <<~YAML
      ---
      name: "Example name"
      description: "Example action description"
      author: "Example action author"
      inputs:
        example:
          description: "Example input description"
          required: false
      runs:
        using: "composite"
        steps:
          - id: random-number-generator
            run: echo "random-id=$(echo $RANDOM)" >> $GITHUB_OUTPUT
            shell: bash
    YAML

    output = shell_output("#{bin}/action-docs --source #{test_file}")
    assert_match "Example input description", output

    assert_match version.to_s, shell_output("#{bin}/action-docs --version")
  end
end
