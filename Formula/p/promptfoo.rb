class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.19.tgz"
  sha256 "e082fd25e52b3c43c99314c20a0c20d55fc209235a9b4f8e701d358b3a977acc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f23e48d299d511fea1abcdce4d0275866ce6b4961e4c1548fdc819ffad02e889"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8802ad74444ce3f2fc54245a802390d0b826bd06f1e7541a23bc649dab929c9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a65f5ea06bb93c6359342850d34fa44b6e6acf5fa677a061e18e116fe46d34d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "007e081c26f81ef6b8432eeba459a392b8b1465584c9f03b82fb0170589b819b"
    sha256 cellar: :any_skip_relocation, ventura:       "abcedf3183e59ff3a354b445658a37a414ac25637d9fef11f61fd9f513e9a556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c12e7ab27a3dad265fc2fb03488e4ff0dafebd79e6920071c3b29a3d44f97102"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
