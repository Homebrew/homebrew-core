class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-2.18.0.tgz"
  sha256 "36648f3eac29670858ed0d230d3f45dc74743c020e6d08fdfbce168a78afd99a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "60962524f661afc9f7b7acba0fba4c0808f595bd61c025ba982315c94fdc84c7"
    sha256 cellar: :any,                 arm64_sequoia: "2ba3331a96d7fc2919634b200c87a1e38f26d77037df601254418408c974e6ff"
    sha256 cellar: :any,                 arm64_sonoma:  "2ba3331a96d7fc2919634b200c87a1e38f26d77037df601254418408c974e6ff"
    sha256 cellar: :any,                 sonoma:        "7a17739ddd2e74d127c470a91d1e17ced466364609ac3d32d91915042d1a2c01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc8c743239b5febd3511950ca6eab3ff0e7c751697660dc9e174a99c1bf84d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4488f59922c3f2f5d4f3a0c239cf904f2afcc5bb36562b0ad4f55ff924a639dc"
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
