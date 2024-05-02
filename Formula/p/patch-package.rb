require "language/node"

class PatchPackage < Formula
  desc "Fix broken node modules instantly"
  homepage "https://github.com/ds300/patch-package"
  url "https://registry.npmjs.org/patch-package/-/patch-package-8.0.0.tgz"
  sha256 "4d2bd29c0d73a6eb8c43270125998bb7586d4f4128a2f1f7002e69edc5fed8e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3755be156502d4299ffa798a6f4600e8c4397c3ae262a9bdd44eeb30f16732d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3755be156502d4299ffa798a6f4600e8c4397c3ae262a9bdd44eeb30f16732d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3755be156502d4299ffa798a6f4600e8c4397c3ae262a9bdd44eeb30f16732d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "aad33f8dbdd1315003bb356498affe9a92a3a75d83d6aa80ce8fdea95b88134d"
    sha256 cellar: :any_skip_relocation, ventura:        "aad33f8dbdd1315003bb356498affe9a92a3a75d83d6aa80ce8fdea95b88134d"
    sha256 cellar: :any_skip_relocation, monterey:       "aad33f8dbdd1315003bb356498affe9a92a3a75d83d6aa80ce8fdea95b88134d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3755be156502d4299ffa798a6f4600e8c4397c3ae262a9bdd44eeb30f16732d9"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/patch-package 2>&1", 1)
    assert_match "no package.json found for this project", output

    (testpath/"package.json").write <<~EOS
      {
        "name": "brewtest",
        "version": "1.0.0"
      }
    EOS

    expected = <<~EOS
      patch-package #{version}
      Applying patches...
      No patch files found
    EOS
    assert_equal expected, shell_output("#{bin}/patch-package 2>&1")
  end
end
