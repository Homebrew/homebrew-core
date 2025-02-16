class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.104.3.tgz"
  sha256 "4748b9a2d7d40f2bc1a2d10cd78a14e2486120c4edc5e08230a8045e458b705a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db7ca75463a7888fc92e15fb6ca9170c691dbf747367df89134f0de8bec45216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ffa84aa3c8504b5970b1c8e80b473f039d9513a701ebdb5a16cd6c62722b314"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89b0758ace55ad5634371d244a47262747bec6f649bde66d9dab7a919c81c032"
    sha256 cellar: :any_skip_relocation, sonoma:        "347e4bbd15d6c7f315a5e907ee77395161359d726d64c1a18a7dd97e2e1f9b25"
    sha256 cellar: :any_skip_relocation, ventura:       "a2998ef5d02ba3dd925b7ce9cd86fa8ededa48f79bba4792e9aa8c28e6e7f26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccd0d55c93083ddcf56c267e1b27123d756cee8ede313c4441dff33ccec8fc9e"
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
