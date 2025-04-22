class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.75.0.tgz"
  sha256 "fd6f16ee527f7a1404a2cbcf3472237f64e6ec947dd9be202f3338a639ab51e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd4e2abfeec277d5a50d7a33b7055678d87a166528ffbe5c6f005425581caa9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd4e2abfeec277d5a50d7a33b7055678d87a166528ffbe5c6f005425581caa9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd4e2abfeec277d5a50d7a33b7055678d87a166528ffbe5c6f005425581caa9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d20ab359f66edb38a09c27535e00aa2f70bd2a70e1a7150125b556839dbd4e9"
    sha256 cellar: :any_skip_relocation, ventura:       "3d20ab359f66edb38a09c27535e00aa2f70bd2a70e1a7150125b556839dbd4e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd4e2abfeec277d5a50d7a33b7055678d87a166528ffbe5c6f005425581caa9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd4e2abfeec277d5a50d7a33b7055678d87a166528ffbe5c6f005425581caa9b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
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
