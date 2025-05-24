class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.113.3.tgz"
  sha256 "8a7ef22428cc1524f95aeb97d1ffc20f4081157090131ec1013e1fa6367b4422"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9815978c97e074f95b948773141accb3536ae8d8f1241c44a719ccf0a6d38b8"
    sha256 cellar: :any,                 arm64_sonoma:  "ccff5b6193dd46c597cf34f117727db08f6af09b855d410a84d9c29f94baa34c"
    sha256 cellar: :any,                 arm64_ventura: "2f147ef6c5b3a330e0a17a55741e034c6a00310e06af3caf97da5b76dd39382c"
    sha256                               sonoma:        "962777484f5d24b451f15226f9512ba7b6d3add7a6742f28f38f7c24a743c99d"
    sha256                               ventura:       "fdbb8ac4cd92ab1b6930c7e50b7399c7f041990b0e4fcd2acb1a5ebe475a6af9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75b2fa7e390e7017f4b905a6eb7943c245d65dfbab7b12e234a216a8d76d7aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab81b00700da4d6330fa488fc2db3ce32578a503d19d3f51cbd32a017dcad68"
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
