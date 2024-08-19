class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.78.2.tgz"
  sha256 "a559ac9cca49b54747843225d86fc5b6e13f78fdbc0891f54de36d5f5f59ee4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9672e9f1bdc166e53f5debc3af2a5bede4b43a81b98bdf334fa0fced805446a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f91b211cd96564a6f2f7299c28693130b2179d88cf9be050bf09d7f812c5d6f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ad644db585bf2517f7a8bf57a856c64069d101086882bed47275391bc66df57"
    sha256 cellar: :any_skip_relocation, sonoma:         "12071c958a57c3e9158a0d2cfff3dfdeb336cae2d5830230e8d8cab87c82a1b9"
    sha256 cellar: :any_skip_relocation, ventura:        "f5aaea0f35c79cffbcd6331804dd0d00cf3a80c94434625b0e3f1d18d5a055b2"
    sha256 cellar: :any_skip_relocation, monterey:       "ccc0bc92fce308c3d0f12e07fccec27e7ec68455bc63cb6d3e30af1c3129fd4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3da3ccedf7198a01ee5fcaf3eb66f72143926be9758063c980a95b6a3d056a6f"
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
