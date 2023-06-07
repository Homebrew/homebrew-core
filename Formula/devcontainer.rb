require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.43.0.tgz"
  sha256 "8253c8d28d06843a00be72acd0cc69af0304c56fb7997164fe75c23d42b6010b"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "c7dff50aec7b9ac59b5e1590dbc0c95c9258fc37500f6d7978cada47310b3d88"
    sha256                               arm64_monterey: "e9dfbcb0703bb2828985b03d3f9ec62a82bee970b98b0dc32554db47ef1515c0"
    sha256                               arm64_big_sur:  "ab49b612ca6bfae5caf0ba743e6119b0fa59ee77941e1e4acbb46a718bada269"
    sha256                               ventura:        "149267d58a84e34f6b5ae0036be03bc032aa081e592bcef6b688ca5e60b7a035"
    sha256                               monterey:       "2c3489ae5b40df61324f291b42dc7b7361ee0a115d096882673eb546d14bebd9"
    sha256                               big_sur:        "7c45afeb3c28ad2ef603369bb24b0426074f29f232ec9064f3a1044f788850c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e98cc2fd61d5dcd1bbef9978cfc9f795432c49de1c8471ad87a728a674c477"
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
