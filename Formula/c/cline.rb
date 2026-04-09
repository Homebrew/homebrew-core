class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-2.13.0.tgz"
  sha256 "0f2f6af18c8c99bc74b9ae5f18fe5ef22e7a8eaa787f4cf81e8b9e944fe209da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8cb8d399ac4863e86d39bd3714e1e4e44ba7bc94e01719b3875a9878f1360b7"
    sha256 cellar: :any,                 arm64_sequoia: "b55c90ea9054bd257ab57650dba5d119c84878a75297d7423fab0e0e26dbb65f"
    sha256 cellar: :any,                 arm64_sonoma:  "b55c90ea9054bd257ab57650dba5d119c84878a75297d7423fab0e0e26dbb65f"
    sha256 cellar: :any,                 sonoma:        "aac055aef7a388bff0847db9a663cf69369c2b27ae5e6ea9452239aa1318fb94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c35215514d7941cb2b46039f63e97bc9ee7ac865800fce3e32a5559ae18cda1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b352ce58830dc33113489e0043b47a447607e72163923da80993a3791d6e6629"
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
