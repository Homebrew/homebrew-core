class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.111.1.tgz"
  sha256 "a54d2df166a3aab68511c563ed74773c299262cba7a292c7041eaa4139f0df99"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ba6e6d165ad313846c851d329c400f6bf3379462b41d6804e95a9b59034db4ef"
    sha256 cellar: :any,                 arm64_sonoma:  "9a62f9213f12436245bcce79e2d14af51bfc128076e2c725bd3e4cd41fa6c378"
    sha256 cellar: :any,                 arm64_ventura: "d50fa57f00ef2e3bf8cd3bdf0f81b543a82aad8ad42253fb366f8ccac28e05f9"
    sha256                               sonoma:        "affe97c215c1e0c3304a25d31225b35955b187be6ee21e119fd44a9e15a92675"
    sha256                               ventura:       "821e1d49e283af0039ad036ba2c5fd08eb93be38242c1f35aa1e2e89251a5934"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a9949ece504affd127cb991fe0b60e09cbf68162945103c28fe7efde405b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af859bdf038e1e90122e3f4262f375632da21ceb5f8fb578ae409818bc8a75c"
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
