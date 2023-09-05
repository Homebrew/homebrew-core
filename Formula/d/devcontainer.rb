require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.51.2.tgz"
  sha256 "ebe17d5f064bdc412d15ee417fabaf31ea21a7c9cf255de3980224d7638ef090"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67ea8088224a52b45bf4233b27eaaac1c9892ec185d9b92111e53ab5a65bcdcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67ea8088224a52b45bf4233b27eaaac1c9892ec185d9b92111e53ab5a65bcdcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67ea8088224a52b45bf4233b27eaaac1c9892ec185d9b92111e53ab5a65bcdcd"
    sha256 cellar: :any_skip_relocation, ventura:        "55a0beafcce1935b4bb67a45af42ed53275549846eea280e3a92803e785009c5"
    sha256 cellar: :any_skip_relocation, monterey:       "55a0beafcce1935b4bb67a45af42ed53275549846eea280e3a92803e785009c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "55a0beafcce1935b4bb67a45af42ed53275549846eea280e3a92803e785009c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3f7667437747f6af07056c915632d76bf0dd2d102c8e9d63222fd92d9a602a2"
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
