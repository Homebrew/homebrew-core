class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.10.tgz"
  sha256 "67c95a5ab0be93c02a0805db6dcf31e130e070b71c5d0d78c8de051f8756777e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f2e9177b1749163136451920a2d22d1a5d76ab9d66296629664cbea4995ed4d5"
    sha256 cellar: :any,                 arm64_sequoia: "f4ffe0f65ab11a3bc352fd64210a08d166db27ef15fc82ffb2fcd70da229cf92"
    sha256 cellar: :any,                 arm64_sonoma:  "8e4f2bb59663a0763717a1459a0af80a4f8c14217be7112350a5cf20bfbdb0cb"
    sha256 cellar: :any,                 sonoma:        "4b266af3d9564011d5a02a3c400b43083e9e512771e1af1c963ab99fdc113517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba3e660cab1aca41a000ccf885f782cb124f25c9b61145199628f265b3425984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd740c05fc19c08c527174b641f9ddda2dbbf81d534165298cfe9b96c551c457"
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
