class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.6.2.tgz"
  sha256 "2fb68942f82a97d7441b4b222b4617f0279d7c350efca9c8810009d76f512696"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "68be80e76678f8bf030c754610593724b8bcc0e7b0637309d5fa7f088355d8d6"
    sha256 cellar: :any,                 arm64_sequoia: "e940452951b31b065af60faee407de27951dbf1b18fcb8d3a38d0433f0868006"
    sha256 cellar: :any,                 arm64_sonoma:  "e940452951b31b065af60faee407de27951dbf1b18fcb8d3a38d0433f0868006"
    sha256 cellar: :any,                 sonoma:        "018b8379011e00f761867fe7939bb01a0fe7228e1d89ca4f9c2b99db22704c9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf1ffb44f87d736ce5687535d030584faa4626f16dff6662d62f7c18efff7c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d8cca7ae670b8b210a78db5da34d4747190946a9f9f5ef6778622b389701992"
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
