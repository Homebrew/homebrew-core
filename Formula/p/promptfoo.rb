class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.116.7.tgz"
  sha256 "f88d089f08005ee2db0bd28db946076e7237dbd699c1a5128bfd988bdc4705b0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ab460d3c721725e3f7471de3bb1757ad2fa0ec50310a8ba0f38c51271509cb9"
    sha256 cellar: :any,                 arm64_sonoma:  "a362ea1243b38ec6b1f633f8c555bfe38d2695a9e8bcc53a7dae25f0e0fc72fb"
    sha256 cellar: :any,                 arm64_ventura: "560ab14d1b91038fa36ea6423ed8d9768ddafc09efe316052d1f083b1370edc0"
    sha256                               sonoma:        "ce72f9c7b999cadc23d71f35b5964fc97c21422dcbc081c6d702ebf380272098"
    sha256                               ventura:       "09d0c6fcef5b3f446f19f23becdec8048c031641b4f43a5a79ee1e7260f16cbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "919d67091cae75e2d29ef8d73249056611f4a4b6b17d2d73214cfa48fcd38f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e2311da8ceccd99d657ddd98f7303c31a49b36945eb6bb34363ccdaca5330fc"
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
