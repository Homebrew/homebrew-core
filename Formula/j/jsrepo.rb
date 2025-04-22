class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.47.1.tgz"
  sha256 "ea2a8478fea26d20ac7034d22a73ff9c3b2052a2f1adb6a7e04efb47274cfe92"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "455c3aa3bde815c831b8e03447809673e4a756c926011673efad8a605a3cbdc0"
    sha256 cellar: :any,                 arm64_sonoma:  "455c3aa3bde815c831b8e03447809673e4a756c926011673efad8a605a3cbdc0"
    sha256 cellar: :any,                 arm64_ventura: "455c3aa3bde815c831b8e03447809673e4a756c926011673efad8a605a3cbdc0"
    sha256 cellar: :any,                 sonoma:        "11d8ad1ef59242cea86f19ccd3424f151a9980276440cc564b5006e235927c0a"
    sha256 cellar: :any,                 ventura:       "11d8ad1ef59242cea86f19ccd3424f151a9980276440cc564b5006e235927c0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ad0071081a6592b94e89a3611a08475426e8a4b3eff1a409eba84914c71d152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b4853fbda213bd746053593104742db6496dd58c1ff16e2788909bf0bf3375f"
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
