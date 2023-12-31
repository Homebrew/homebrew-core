require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.55.0.tgz"
  sha256 "b92ea099c2d363990e83f4e1b716610e398805f37664348af717ce02412d915c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7e4315c9091d31791ae23a26c0aa8834bd060e851223ca4506b4a8a72d95677"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7e4315c9091d31791ae23a26c0aa8834bd060e851223ca4506b4a8a72d95677"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7e4315c9091d31791ae23a26c0aa8834bd060e851223ca4506b4a8a72d95677"
    sha256 cellar: :any_skip_relocation, sonoma:         "f519c8ff33913133c8a1daeb9cfa5f3c7b1de7aa19b36c0d8cd70b28e75c197e"
    sha256 cellar: :any_skip_relocation, ventura:        "f519c8ff33913133c8a1daeb9cfa5f3c7b1de7aa19b36c0d8cd70b28e75c197e"
    sha256 cellar: :any_skip_relocation, monterey:       "f519c8ff33913133c8a1daeb9cfa5f3c7b1de7aa19b36c0d8cd70b28e75c197e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7e4315c9091d31791ae23a26c0aa8834bd060e851223ca4506b4a8a72d95677"
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
