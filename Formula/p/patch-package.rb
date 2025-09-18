class PatchPackage < Formula
  desc "Fix broken node modules instantly"
  homepage "https://github.com/ds300/patch-package"
  url "https://registry.npmjs.org/patch-package/-/patch-package-8.0.0.tgz"
  sha256 "4d2bd29c0d73a6eb8c43270125998bb7586d4f4128a2f1f7002e69edc5fed8e2"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "5f5aa0acb3f3dbe909a6f06181218d216342a95554c5338ca894657322ca0f31"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/patch-package 2>&1", 1)
    assert_match "no package.json found for this project", output

    (testpath/"package.json").write <<~JSON
      {
        "name": "brewtest",
        "version": "1.0.0"
      }
    JSON

    expected = <<~EOS
      patch-package #{version}
      Applying patches...
      No patch files found
    EOS
    assert_equal expected, shell_output("#{bin}/patch-package 2>&1")
  end
end
