class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.115.0.tgz"
  sha256 "0018bbd58486824c684f6b4966f0f62d9e6cd000f59e87fcfe0e6b25f4899dcb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a0cca08085a26ec8e1853567a50c4665b7d7b97ccb07aa97ec8824f28f8ce670"
    sha256 cellar: :any,                 arm64_sonoma:  "b6753b4ada0d6faea81b795beadf932d08f2ad8f7bd37d7893e90cfb4d22f2ef"
    sha256 cellar: :any,                 arm64_ventura: "cdd16643056ab7be6bd324d20be8155f6bbf53d3cb16d56c55499c334d7360e0"
    sha256                               sonoma:        "742eb0d3aad200d897c64cbd344d9ad80ac987758d8b46c8b11b498ce1f7a2d4"
    sha256                               ventura:       "f2b654f76d89a738ed20ccbb92274bfc254025b0af7397e70c391bc9ccc14aad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82bccd027067837a29b122b490bb9b5514323ca3a1950e7c6e9d5775cd7182d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c1110c1e98e65ea9548acb037ef7541f80cf5fcf6e973c1eef4bbe6d8c4e312"
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
