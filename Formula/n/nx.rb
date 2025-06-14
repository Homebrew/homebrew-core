class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.2.0.tgz"
  sha256 "187250adb2505d659caebf8644e9c47b185a4f7efba508d75b97ce0e515e2cca"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3d69ab9b9ca6e037ee3cd91b7ac7105fa4b706b2301b38d48d5cd120186b1de8"
    sha256 cellar: :any,                 arm64_sonoma:  "3d69ab9b9ca6e037ee3cd91b7ac7105fa4b706b2301b38d48d5cd120186b1de8"
    sha256 cellar: :any,                 arm64_ventura: "3d69ab9b9ca6e037ee3cd91b7ac7105fa4b706b2301b38d48d5cd120186b1de8"
    sha256 cellar: :any,                 sonoma:        "4c6a19b58d5131dfb3cc313c9471b0519a2a6d9b7b6165f737cb406647c14921"
    sha256 cellar: :any,                 ventura:       "4c6a19b58d5131dfb3cc313c9471b0519a2a6d9b7b6165f737cb406647c14921"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "941a169e2a792954cd4af6691eb0909acb75a04a629ce22fe7320e3ca93e829d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a12731c50cdf0c57320fb151d2be5460aee30f374f2a74236c73a80de1146d30"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end
