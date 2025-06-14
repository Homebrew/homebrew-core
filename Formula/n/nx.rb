class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.2.0.tgz"
  sha256 "187250adb2505d659caebf8644e9c47b185a4f7efba508d75b97ce0e515e2cca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a9de6b9effd88b368216735d056b0d54f2b0e833797ef087d43feaa1636595ea"
    sha256 cellar: :any,                 arm64_sonoma:  "a9de6b9effd88b368216735d056b0d54f2b0e833797ef087d43feaa1636595ea"
    sha256 cellar: :any,                 arm64_ventura: "a9de6b9effd88b368216735d056b0d54f2b0e833797ef087d43feaa1636595ea"
    sha256 cellar: :any,                 sonoma:        "12db68c72af60e7c8517aa41a251e6dfc082dc4a54e01ebd9a0a9a9b885d963b"
    sha256 cellar: :any,                 ventura:       "12db68c72af60e7c8517aa41a251e6dfc082dc4a54e01ebd9a0a9a9b885d963b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e6d4cfb967affcdd97e8db23f7a45ea307f2c2c6cca3c95e50b5deb85d5b449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "165f255e6d05e1ecdabf4052806411fff11d1bc66044c920d8903a93353e6ded"
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
