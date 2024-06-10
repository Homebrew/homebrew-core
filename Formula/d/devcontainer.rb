require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.63.0.tgz"
  sha256 "ba685b676af25933839b97bfb07e376cb96b5f55d18b3f63ce2f51e726359d11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54784a0fe265a6a596bc37e792db6c5b59c4c3071903834584e3f019407d68c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54784a0fe265a6a596bc37e792db6c5b59c4c3071903834584e3f019407d68c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54784a0fe265a6a596bc37e792db6c5b59c4c3071903834584e3f019407d68c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "1255f2173e761096746f39e695ccd506e84d69f250dba5e7bbd14ea09c9465bd"
    sha256 cellar: :any_skip_relocation, ventura:        "1255f2173e761096746f39e695ccd506e84d69f250dba5e7bbd14ea09c9465bd"
    sha256 cellar: :any_skip_relocation, monterey:       "1255f2173e761096746f39e695ccd506e84d69f250dba5e7bbd14ea09c9465bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3ad57824d918a60ee339fd92e25760833201570a1a562b57d1b3f81ae0f356d"
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
