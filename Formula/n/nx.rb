class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.5.2.tgz"
  sha256 "fd22c958de5e5b9d9251ca81f837b050aab867b67af9b2119b207b0dbb6ed59a"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aea8f2ca275ddc9416a8ab281103c4fe095cf361ebedfff8155909870b1945a1"
    sha256 cellar: :any,                 arm64_sequoia: "37c8a6ca7fd27f5a9b911ce7f841897e2c5ef0ebfa83244675efb98e5e8c7061"
    sha256 cellar: :any,                 arm64_sonoma:  "37c8a6ca7fd27f5a9b911ce7f841897e2c5ef0ebfa83244675efb98e5e8c7061"
    sha256 cellar: :any,                 arm64_ventura: "37c8a6ca7fd27f5a9b911ce7f841897e2c5ef0ebfa83244675efb98e5e8c7061"
    sha256 cellar: :any,                 sonoma:        "23b130c15acae14e880e120a210044f005661ea48fedd4f5ea7979904bb9e341"
    sha256 cellar: :any,                 ventura:       "23b130c15acae14e880e120a210044f005661ea48fedd4f5ea7979904bb9e341"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14f4c4a4cdafd9d646762e771841c5b029ee756bf00d9e1a6529895437375a20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28196ea358a00885e6e9315176235cd6b8945960cb0ce20aa99cf72903a8b816"
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
