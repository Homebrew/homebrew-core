class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.1.1.tgz"
  sha256 "27810c06e1d0f64a448ccbe5ea4ce61f3e484bcb2d94eef7706550146b481bda"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc092d9ec0c434a57b63ec7b8bd2318d0ea0b693a799e354bf51e6fedb3bbce6"
    sha256 cellar: :any,                 arm64_sequoia: "8052d267677fe9d065677bf29ac83baf62e8e871ad4ede4f49376de9471a5aa1"
    sha256 cellar: :any,                 arm64_sonoma:  "8052d267677fe9d065677bf29ac83baf62e8e871ad4ede4f49376de9471a5aa1"
    sha256 cellar: :any,                 sonoma:        "63a92c6a56bc97953574c91a7f923c810cf0f32e1c44edabb1c7705310a75922"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "419277598490b8aa8971f904f609387453daaed0cdce12ed13ff1825592ffa5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e000bd1330e9effc5f912ef43e43135c03febe644359703380e2f31492bebca7"
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
