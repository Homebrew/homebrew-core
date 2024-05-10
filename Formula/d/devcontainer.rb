require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.60.0.tgz"
  sha256 "8cd2e1b42f0e0b7ffdeb41c3e51bea54d44f626348049c351019ba382790aeb6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07d9ee480df398bfc10ff5f68625704a5421a53004d15daf40d816cead8836d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42b87c58cbfdcc46e3708292a2eed3e68cbb6a015b49ef29d5ddaa3fc9d1f1d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bba04eeba3b8f34d4aaba80ef3d03d1681f40fad2de19589e4f12bdab8bb60f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2dd05c1ee38ca37cb9f9ba02b75c7f59f82060b5d750b49d2b0862340ecadac"
    sha256 cellar: :any_skip_relocation, ventura:        "1c6d0442b467df1a739b41a2e31aa3ca86a09d2403862780fd03d716ee0071c9"
    sha256 cellar: :any_skip_relocation, monterey:       "fc2e76450800a3741d9a88d69103a1c97042fc009a24b634f828abeadbb86dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bca82ccf536fdb92d3bcec37b0161aa596e8ccdad18bfc15491c540a50012991"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["DOCKER_HOST"] = "/dev/null"
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~EOS
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    EOS
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end
