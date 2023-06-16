require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.44.0.tgz"
  sha256 "c58924688348478270655a4d72aff6c9b0ef2274ad040c6f151f74e13438a3e5"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "06d3101c142859e38eb583a06a144a00edbe3d98695b572f693c4b60428d5497"
    sha256                               arm64_monterey: "4df57a8b1e7cbc03424196725b0fcf950a754bed2d0fae45650949af1ec81d45"
    sha256                               arm64_big_sur:  "79a649eb50b3c15f9cb102dd5769ffe2f552835abf92b08516ed967a4440f244"
    sha256                               ventura:        "8c8de644da19b2ffc40706b650c1bb8a2995a9f24245937b1ea7d6bb11195ee4"
    sha256                               monterey:       "8de07d5c026ea36802d7fe6b67bbef5d54681365734cf9c80793991f55de297c"
    sha256                               big_sur:        "0c4c9b7f6e94eaf7ad5d72e3b1adbdf7e5a85e95359903b8638a617b97da8c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ab71400d698df3fb90386a39e0c0401f7db1969954e85b498156267ba119869"
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
