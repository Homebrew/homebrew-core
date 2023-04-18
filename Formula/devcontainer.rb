require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.38.0.tgz"
  sha256 "72dcb3e51613a073106cc9c1b8b072430120127e496fc5740fa71d5418535a1b"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "9f775dfe0a44c8961f07eaeb91b9dee8831e0e0fce3aced304141061e7db6e70"
    sha256                               arm64_monterey: "2e8e3d032b1ecdacbae78bfa092804c762b312f180066be5e7f9d280ee42ba12"
    sha256                               arm64_big_sur:  "19d8e87719e96ffe71c066d17e1cf1dde0e47c0d5bf0de0bb33cef0749a77285"
    sha256                               ventura:        "8919bdb325d7c9a3223915f6737f04a5f4ca328c9a93b1b0cc41b2ead4f24d94"
    sha256                               monterey:       "49023144afee03d33815a8d7dc215a40e7f6672fe36fd6a0ace74d83eca1d1f5"
    sha256                               big_sur:        "998e000a775e3819de87759c9a325c7a36875e89fd8735dff83ce762c1b7387d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4562a9a07d4266ca999d7283a384877c32d9a2ccbbdea012403f353a8ab5cdb"
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
