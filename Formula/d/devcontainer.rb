class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.91.0.tgz"
  sha256 "d83e2291a799818ea8abfba634f0bb699f05a8df21376feefb07bb631844f41f"
  license "MIT"

  bottle do
    manifest_sha256 "6ee58d12077411727566f7f6e2889c48c3f1ed8c52c60046215ebdb177f9af5b"
    sha256 cellar: :any_skip_relocation, all: "110fe0f978a9bd419774a3d087e3fcd1d77b4b4b20ec1e368ca2a0f84f2cdd26"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/devcontainer --version")

    ENV["DOCKER_HOST"] = File::NULL
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~JSON
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    JSON
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end
