class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.6.1.tgz"
  sha256 "5b6707f754d24426f0c0aacaa661576c03a35d2e489bd532d566c82f18727a72"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c125318b2054823df66ff729842993da02905c01eeeabec9984fba5c09ed082d"
    sha256 cellar: :any,                 arm64_sequoia: "1035c4734901546d457f5b2980a658783a43119264ddb1ad42294551f68af0bc"
    sha256 cellar: :any,                 arm64_sonoma:  "1035c4734901546d457f5b2980a658783a43119264ddb1ad42294551f68af0bc"
    sha256 cellar: :any,                 sonoma:        "cadd199f46b006907e24602f7003827367e331ba33bfcc4cdda1626bbf99f933"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc780973d34f057e986c1f607a24c22741627f03f0254251dcd7d9d78d53346d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c15ac51cf960cd7eae8bb9fbe413810066dd10dcf98b94110f67dcb976ca9094"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx test").gsub(/\e\[[0-9;]*m/, "")
    assert_match "Successfully ran target test for project @acme/repo", output
  end
end
