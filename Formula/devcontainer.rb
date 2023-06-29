require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.46.0.tgz"
  sha256 "acf6fc85bf6facc533f22ea9f5f16ca5b1f73da8f0963fa5490243866ce8d5fb"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "9ba5388b3a3e483f49d80c7483e69a5fd646a1abdc1b411b4d55c860abf7a253"
    sha256                               arm64_monterey: "383980849e005fec996b1d0c405cb60c376d45f0916d5a313d6d00fe51b1e78d"
    sha256                               arm64_big_sur:  "bd77c7f5c4676559c5da7b990eeafe7143a34c9a42f2157665c4017a9fcda824"
    sha256                               ventura:        "432337d7a48eb33ad3d2832cce7ab42d0dd1d193f1d7e940a2f11f990d415222"
    sha256                               monterey:       "6c1b68f922c8dd3d2dba4192dc28b26fd0b6c8a1f3495f8e8cc8273bffe43598"
    sha256                               big_sur:        "43356d2b97f24513612aa470db20366d4d562d3b8d58eb2e52b7665da0d36234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c9484d13821fff90af8d42e22c1164f2c8ad2d8a814803c54ad8249b9fb00e9"
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
