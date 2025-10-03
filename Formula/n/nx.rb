class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.6.3.tgz"
  sha256 "c345a107db9cacf1e5e3824ea3dafaf6323768da635a90a4c2beae551ffb62c4"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "103079798b68c73e8592b2b48648243cfb30a4c12d7c44b6c4395565ef4d6076"
    sha256 cellar: :any,                 arm64_sequoia: "fed8cbf71acf2a6cfceee5763580714ecb3a73b146cfd038a2482135bf3de069"
    sha256 cellar: :any,                 arm64_sonoma:  "fed8cbf71acf2a6cfceee5763580714ecb3a73b146cfd038a2482135bf3de069"
    sha256 cellar: :any,                 sonoma:        "521e4bff98585a42f234faddb9e5469f44ef328b07537ff2240dbcd046ef0cb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c801332a5fa5ae4243e0cf955c1122f692d5c2995f4ccad149708b567a90b563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef0f0a844a2280073bf1d26d3fb4558ce25c665339a728acf3a09a133d35196"
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
