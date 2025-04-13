class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.109.1.tgz"
  sha256 "01672ff046ea8734b085816f10acc538cbb66d22439310695442d0c71e89b644"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4798e7ffc9f1862ce1b86fdae2f77a465168ba387e3dae5dd2313478e2cce601"
    sha256 cellar: :any,                 arm64_sonoma:  "9231788d737b163b9b8fdbc85b78cfb2476e1f19f6119882ce40baae67c4acee"
    sha256 cellar: :any,                 arm64_ventura: "beb29ae1993e04f58d0144a16b7217c9782e7b8a46f50fdfa73edb9f1db09682"
    sha256                               sonoma:        "3269be02ad7b117d6e7801b1c6c456c5176200dbc0de1f4cab9405b560a8ecfa"
    sha256                               ventura:       "8b9508f9c03d362cf4501d5feb28b6cd37d9cf32333be6300749e3f534ccbfca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae54543887301e9efd22d373260e8a6f68bed0b72ee90f7308badf96cfc30ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53745b49a2f0483052c27371fb16a595df801f7cb05cad164dd7b5f4e2993e62"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
