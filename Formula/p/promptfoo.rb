class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.11.tgz"
  sha256 "af3a5d4b6cc99b25e186a64b9a8db3a294ad47d160fe614b716dade350ed2591"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6dc419f648cc62b84ddd1bae36d99b8ef38dd2313e5b0bdfab532fc3525a7636"
    sha256 cellar: :any,                 arm64_sequoia: "20661ae47c3ac3275a1ed7192075d46e80ba1174c2c268289447364bbc0cc6c0"
    sha256 cellar: :any,                 arm64_sonoma:  "b538c36fbac80b612a08f41d01c7237f0a99d4abf49c7d732530ce803665ae00"
    sha256 cellar: :any,                 sonoma:        "1d6463110d6db316f2a54a224cb43205ef7062c451fb443d8572d397b7c88d21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3453b4063fac99b739f4a1bd12c69578e72c871643ab7c1c74f2ce8a3020c864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d70a21176fa0c2df5bae46462d07615cacf7793ba91a00de7cf4c9688136efb0"
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
