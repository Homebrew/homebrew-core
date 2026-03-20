class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-2.8.2.tgz"
  sha256 "47cd0fdeed0033df9304e116f43bcfaa576ff901678f796ae8455c5cf54dca7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03fde90fab1b40ebfeb15ad4c2d052bf473c2a20cd764aca59301dd1acade927"
    sha256 cellar: :any,                 arm64_sequoia: "de7ed5348889671539778156ee793bbb31250f74cea838d2ca451e2f08c1fd40"
    sha256 cellar: :any,                 arm64_sonoma:  "de7ed5348889671539778156ee793bbb31250f74cea838d2ca451e2f08c1fd40"
    sha256 cellar: :any,                 sonoma:        "66b7340dfeb7d409a23c3a39c6b8f0d87bd249e2272a9f6ad50c4501a6d09df9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f585b51b813918307fb56c7a1a3ee52ea7aa696750ccedc412630549016b2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5affc748c733ca083eff1509d79371815b73222438c99d442bf8e8110215c1f"
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
