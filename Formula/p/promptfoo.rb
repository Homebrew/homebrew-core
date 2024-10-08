class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.92.0.tgz"
  sha256 "2639644bba316a4710a59cd5381384f21f4e5fbf0de8f2ba541117ce59240e6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31361ab97b369a4c2a7fa0b31e5d840e5cbf7d9b7ebf8208c730acacd7b4a2cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34feb39fa9a8636bf8a887c5e3654fa7b4c562618c9db72fd021b57964f5b252"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f87a46027e8ccda27c803a8a119db42886262163a366c58fdfc2f22d298bcb61"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd0ffe559e2bacacbadde52fb3145afb2026d754e2082db8941fffafa5cb66be"
    sha256 cellar: :any_skip_relocation, ventura:       "d5cc6ca7f131d2dbe98c623ab301bf6c71cb7cf5d5c210873d85511e0673d088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a756ed921241c12d7aadffc10292b14ce29998148c84c5c5f22fd4cfe4f7fca"
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
