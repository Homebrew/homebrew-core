class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.14.tgz"
  sha256 "6e3e5576ffc6e8c782778d1f79e6d27a08386213f631d295b51491f93cdc7a5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eebf606c30412bbbf555108b60e4f068fbb63907b21f173ecab0941d2864ab10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eebf606c30412bbbf555108b60e4f068fbb63907b21f173ecab0941d2864ab10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eebf606c30412bbbf555108b60e4f068fbb63907b21f173ecab0941d2864ab10"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eebf606c30412bbbf555108b60e4f068fbb63907b21f173ecab0941d2864ab10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ad5d61c076e7c897986b9908fab54483bbb3add01943282c5e3ca38b7c6ec971"
  end

  depends_on "node"

  def install
    # The npm release is already transpiled; do not install its native build-only compiler.
    package_json = JSON.parse((buildpath/"package.json").read)
    package_json.fetch("dependencies").delete("typescript")
    (buildpath/"package.json").atomic_write(JSON.generate(package_json))

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
