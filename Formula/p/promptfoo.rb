class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.114.2.tgz"
  sha256 "e8705093ff4810c9a2f3316e10e6ee6c6b7cc066d94f07e69a074ee20173cf62"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "586dad07d03487f87c68d4d0027ddc58ee58681fc60a6035313039ef8b16e565"
    sha256 cellar: :any,                 arm64_sonoma:  "a8eaa84237a5f400f6feba41079fa759d8c2092079687a82382c5afeff2bbf6e"
    sha256 cellar: :any,                 arm64_ventura: "fc5df4ba26bba21fcd63d2520a551e6cfde73c8cd5f059dbca6c1aca7a1607a9"
    sha256                               sonoma:        "2411033c9bb5d6ca7051df55869991395532d2317d16816c28cc9ac542b4b621"
    sha256                               ventura:       "334b77805235ced815eb7c3a704e11620290ff05d01b7873f8abc5e72f9b2d90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2538670e2a394c1f0f78f2e92c737246e647efc689526660563948547fee6287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc9a65af903b69dbfd50dc6af40732929ce36cd3ef0363923546503f909bba86"
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
