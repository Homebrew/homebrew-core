class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.92.3.tgz"
  sha256 "9e5696bbf6277a392e01bec1c02e269e170a6e5a42685280ee3180f39c8e6a1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "917fde2b829926ec20b3c55d9c09ed49830b0d2098ada101d00e4a6413cc5f7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f49ac8653392e1d3fdc0a3a5409d266ab184e24c82acb035edeebe8399b06f52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3af987a22a5dff0e46b754b729da6c0d17a5162cf57c7a18b4f2501137277204"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae92cbf202cb0977d7fef45c828e316e3f6c1253ce9e6539fcd085ae116dfcf7"
    sha256 cellar: :any_skip_relocation, ventura:       "197895374224613f428e7b1f59fd63e0b4994d8528914dc15accd51ffe7e612d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b3bacaa9e9b91b2cda7f1be7916a6f6b132eccf5a054badaffac5e41ed9582a"
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
