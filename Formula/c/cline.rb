class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-2.14.0.tgz"
  sha256 "80a92b4adcc54d701b7529d71708da5e76e5a8cbd050a55c90cf8c5030941faa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03c2f6278bc5d5d88f9caa9f7d53a6d6f65372f1c9f2bd01ed5b87bccd03e926"
    sha256 cellar: :any,                 arm64_sequoia: "f0d84cccbb1739e432cc0b928b2835905e116700d297d18edf43ed0601f027d4"
    sha256 cellar: :any,                 arm64_sonoma:  "f0d84cccbb1739e432cc0b928b2835905e116700d297d18edf43ed0601f027d4"
    sha256 cellar: :any,                 sonoma:        "360361cd83433d958f9e2741ca2bd65426c299f8c894f52476afcd7e8fb55eb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "713d771cbd9b2b761250efbc352aa122882c24088345ba077afffd3c85493838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd2cecba3fa1526cb1f8f5d4877668903b3c6b0c4a22ad4f96a567d422b1b629"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # https://docs.brew.sh/Acceptable-Formulae#we-dont-like-binary-formulae
    app_path = libexec / "lib/node_modules/cline/node_modules/app-path"
    deuniversalize_machos(app_path / "main") if OS.mac?
  end

  test do
    expected = "Not authenticated. Please run 'cline auth' first to configure your API credentials."
    assert_match expected, shell_output("#{bin}/cline task --json --plan 'Hello World!'", 1)
  end
end
