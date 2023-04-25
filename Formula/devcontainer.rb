require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.40.0.tgz"
  sha256 "3619f2367b287817560445030b9bc6e7746706b1c5e5a2690d7521310be7d791"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "f5325d5e3e257b9091ddcdde83733318dd6cbe680394ca4832ef1a7f618cedc0"
    sha256                               arm64_monterey: "520edad0a04ec0f0fb6ad7ffe43c89f7e44d6ac9d865b2e53c584399e922cfbf"
    sha256                               arm64_big_sur:  "e3a9668b2cb3e242f364fe0ceca2fb688a3c92c3553e36bd9b50f0a17b7194e4"
    sha256                               ventura:        "e65bbf10debc93bdc5386b12e8ceb3e6c6300c456b7fc0d1e75e0db0c991a863"
    sha256                               monterey:       "f1025ff33dad32f021af81741388c3934d72119ef72f42e23699f1e3724547ee"
    sha256                               big_sur:        "24102d6c005f30ca610804ec345545babc6dca178eea0cfe33ec6d4a564e9be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9bdf3c469bb8f84f553ced0a3953b8b9f211a24c31c336a336a8637df702f0a"
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
