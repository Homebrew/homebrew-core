class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.43.0.tgz"
  sha256 "591f81bf2bbcf21633009e94735424733d39d01949b4dad4ef042d18d510ca7d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b80056680e9a10ed31958194a9abc5ff40d1b78eddc84f37d8f14e9acb5ab6e5"
    sha256 cellar: :any,                 arm64_sonoma:  "b80056680e9a10ed31958194a9abc5ff40d1b78eddc84f37d8f14e9acb5ab6e5"
    sha256 cellar: :any,                 arm64_ventura: "b80056680e9a10ed31958194a9abc5ff40d1b78eddc84f37d8f14e9acb5ab6e5"
    sha256 cellar: :any,                 sonoma:        "2e5acd00eb4cd92c1edf15ee5275d41d1fcf705fe8f297f85e7f4d22200a309c"
    sha256 cellar: :any,                 ventura:       "2e5acd00eb4cd92c1edf15ee5275d41d1fcf705fe8f297f85e7f4d22200a309c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db727dccc9ed563fcf3524e01fd0c99f08975d2a7fcde331e600b6959d28d94f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end
