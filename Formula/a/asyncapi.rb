class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-3.5.2.tgz"
  sha256 "a4d1441ecf78caa50d83fa6a9e8127cf51a5e44c135ee0da32e47265fef0c6b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a97f8c379e1e7308cea4c2369117aebbc662a3285d09c027e084f6f2052f85bb"
    sha256 cellar: :any,                 arm64_sequoia: "ef9df01bf19a806211e356792ad3a25c7e787016ee5d420b13af2a0c9586f728"
    sha256 cellar: :any,                 arm64_sonoma:  "ef9df01bf19a806211e356792ad3a25c7e787016ee5d420b13af2a0c9586f728"
    sha256 cellar: :any,                 sonoma:        "345b5571ec72c2914535f636e764e85a48f4c272555a23ff03bac72dedcfbd41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58480120d827b34911bc7c2cd1db40f4404df26aee13d21aa90ca33ac5e68bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7594cfa94fe6b6e221bb268e13cb1f110e0e81d77bbec4ff608d34d8ef05b235"
  end

  depends_on "node"

  def install
    system "npm", "install", "--ignore-scripts", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Cleanup .pnpm folder
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    rm_r (node_modules/"@asyncapi/studio/build/standalone/node_modules/.pnpm") if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end
