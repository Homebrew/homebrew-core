class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.4.tgz"
  sha256 "61bb56e4890b324ce215cf3a99b8700e89f9eb7fc909cda20d81ccfb92f04497"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dee668083bd7710c4f41d4512096174a8682755decc12caacd0fec3c7122b7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a25698452d49b9eb8e5065019a37ad53a6846c880dcda9ec3b7b3fb42807315a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a25698452d49b9eb8e5065019a37ad53a6846c880dcda9ec3b7b3fb42807315a"
    sha256 cellar: :any_skip_relocation, sonoma:        "124eabc854e763ab61b3052180628e0e3bf40a0172c724d594aa1ca976159970"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b5d8b8aab139b687ea90c2b404d6a3eb7a854ce304dc15fadf76829b87ad4a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b5d8b8aab139b687ea90c2b404d6a3eb7a854ce304dc15fadf76829b87ad4a9"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
