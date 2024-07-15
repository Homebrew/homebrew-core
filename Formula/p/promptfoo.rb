require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.71.0.tgz"
  sha256 "afb66390f33acee4d058f36fc5d03ea4c8220c79e36c6d1160838a6d49a4f2a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75ba1ecbfeee6e429c09a91f506335ea174c877b067ad7b5194cb0b41ce54db9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40f22ae717a1c09396c692367e422995fa4f1d6c67595e5853102e44b9eecc0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd10da7a7b397ba0e55bb6f20d60b1d9221f7d7d66f70fddc2a9ad9ad7074f76"
    sha256 cellar: :any_skip_relocation, sonoma:         "a489fdb6840a9dcfdfd7a13fd12ff3f3df4f1b045b9930338ea0123bb65da332"
    sha256 cellar: :any_skip_relocation, ventura:        "6e27e18da93f654150ecd00ca5f209c34226c4bba6f3b072cf1e20f2b28eb462"
    sha256 cellar: :any_skip_relocation, monterey:       "c94bbe49802fc25c76d9bbeb8a4ebcea043f72ca5bd1a884ac8912b4496dd211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fff2397ae32d8df3d1643945bf943fb868a71dd3ff07a316c6f910244e988d0"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
