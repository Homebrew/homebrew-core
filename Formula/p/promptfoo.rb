require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.71.0.tgz"
  sha256 "afb66390f33acee4d058f36fc5d03ea4c8220c79e36c6d1160838a6d49a4f2a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b61048aaa07e99b4bf0283bb42fcac4c03620a39637064f57d83651e726809e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "573d8d7f9cf873669f68cbc2e5edbc3a89be67e0226e3947486b26d974a40225"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9145b6351cd6a132d58b93e5415d77b362900e9c1e9ceee4ca7d7e42e2300e55"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b42be8a177825e4f176b08983f41c01c289f18201daed6e485441a2bcfa5375"
    sha256 cellar: :any_skip_relocation, ventura:        "11c82d3868997e9c5d294ce0b3c769bcb4b40f014b33c0fa381e89921e32c227"
    sha256 cellar: :any_skip_relocation, monterey:       "3fce3e875110c3e9496fe9f579c684dc8333ce32849207e65f2337641396cd6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c98f1859a5572ec65f1e8046f917ddfdcdf2617cf5fa9ace2e027fddc4069be"
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
