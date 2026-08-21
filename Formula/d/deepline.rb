class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.0.tgz"
  sha256 "4c8c382631a64f819cfe4f1e69f4739f72e1903bfd8a4d236c28feb30a45a721"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab33c9186ff5cf19d85723a3d2822f88ea47e5bb0f9ba7f2a7f812f3deb1394a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab33c9186ff5cf19d85723a3d2822f88ea47e5bb0f9ba7f2a7f812f3deb1394a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab33c9186ff5cf19d85723a3d2822f88ea47e5bb0f9ba7f2a7f812f3deb1394a"
    sha256 cellar: :any_skip_relocation, sonoma:        "53fe6685944e7ae4e42a9b1366521e50c8da442bfaa0a97eaa0cbec622b1bdf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b07e5fcdaf315df1f09a73da97554be7510e859808274eca7d0d388a4b391226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6852b5b001b1821778db30956f0ee74bb5020c1352e8dfe375d54528ceaac4a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
