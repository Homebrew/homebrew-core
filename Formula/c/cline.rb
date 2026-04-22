class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-2.15.0.tgz"
  sha256 "07da5a9622a4f74e6c462cbbf15994ea50f542c69eadbdc6abd3e68ab4b896fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8c9d20768fba3d0b22ec1542d49962ae6e6a3cb5eec0022b9b0cf1e430fed6a5"
    sha256 cellar: :any,                 arm64_sequoia: "9ef8a0efbfd75270e9aeec94516fdf1e5fa89da5f6d90e33dacf32a7d54332d2"
    sha256 cellar: :any,                 arm64_sonoma:  "9ef8a0efbfd75270e9aeec94516fdf1e5fa89da5f6d90e33dacf32a7d54332d2"
    sha256 cellar: :any,                 sonoma:        "3edd7f17a39ef3509d742e528ddba3700d76cd0e8fe3746f438ebd5c021549f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0204fe8de9b1b13ef80cdad5b17240119b56491f85773027cc69f82d37a8b978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f122e9f42ef48521131ce4ead3fee44d41e9b26905fe49ff468dcd4a1930ec09"
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
