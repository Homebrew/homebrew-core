class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-1.4.1.tgz"
  sha256 "ed6be9a7dcfb294e0eebe194d125292602f6539163e11f9f841e14f6ca87ceb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6b7983c1a90617a4049454be740c089e770c3bc3d892f30b4d031407f8edaf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6b7983c1a90617a4049454be740c089e770c3bc3d892f30b4d031407f8edaf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6b7983c1a90617a4049454be740c089e770c3bc3d892f30b4d031407f8edaf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8200d034be09d487b00b9f2498a342f34e0ac822bb9b2a87fcaad80161c7da10"
    sha256 cellar: :any_skip_relocation, ventura:       "8200d034be09d487b00b9f2498a342f34e0ac822bb9b2a87fcaad80161c7da10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6b7983c1a90617a4049454be740c089e770c3bc3d892f30b4d031407f8edaf5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
