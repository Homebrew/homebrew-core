class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-2.9.0.tgz"
  sha256 "fda97242c4fdc46958192f5d27a773e11a1ea65f21b32fcf9b0b491595530360"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "388306fcdb05927544e7653c270dde57bf91c9b9d74840fff9fc15fbfc9c1875"
    sha256 cellar: :any,                 arm64_sequoia: "1f80a2850721dce3cea5fa1562c39fb3b35ee21675310fb3a2f8f4ea6cfddd58"
    sha256 cellar: :any,                 arm64_sonoma:  "1f80a2850721dce3cea5fa1562c39fb3b35ee21675310fb3a2f8f4ea6cfddd58"
    sha256 cellar: :any,                 sonoma:        "897c2a9179c5dc85e75854e153f4194d2b19ee745294e0c926868bc2ef21455b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "979916eafa9143ab70db0c9b2dfd44ba61944d971ac0c083c717c813584423c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d610853235f48ebf77a49e253c3814ed84635ef278fcc664a75a79f6a519c4c6"
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
