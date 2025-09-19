class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.6.tgz"
  sha256 "d57b77c12c59ddaa10d30e7f992333d0f3bdb05baa7d511a80489afeb4c85d23"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f99914e26e670f373c68b74189fac237801a26d493ac01aac50aa5bce6e5c07"
    sha256 cellar: :any,                 arm64_sequoia: "636bdc2d01bdf054e581bb5882f420491ef03929d1c189b522f6856079597854"
    sha256 cellar: :any,                 arm64_sonoma:  "2d691d5fabd8c151f67eae4a571063d912acef3c3e39bde28caccc51b9afdeaa"
    sha256 cellar: :any,                 sonoma:        "e1d00f524bd9aacd60e84c3fe2db5b5b25bebdbe26df5b3257070d08c902990f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a847f3bc439bca5f1b582c35a521c925a7ff5075118d2e2ba970d86f647f349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7505fe1dade82f7ee0fb67240c1b66cb1b8fea87953f246d8e3c6121c9afa1f5"
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
