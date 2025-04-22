class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.111.0.tgz"
  sha256 "9c6485fabb393236dea36536d2f5ab068f0910994585386a6003d21912584f5c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "88226151d381db3dd4d4a75085b09fea22ebe9c97371713abdaa51dfad60b9a5"
    sha256 cellar: :any,                 arm64_sonoma:  "2327aa20cdc06704251a66199261eaf6de9e031e0271ea36590b3511175e3331"
    sha256 cellar: :any,                 arm64_ventura: "c6db3a35c05866a1d7c00b470745bf4508557f3416a54acfc4c56e5509fdbd35"
    sha256                               sonoma:        "d89b7c9471c45e668f76c62085ccf743d3d9b49fe15b581e59239f5f25110eb6"
    sha256                               ventura:       "f5f573bccd97bc06868dad3a7842192bd1ee02e8a6d26a597d754b8b4857a776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a85be5ac72fe3cc93f8634191a0bcb3f55441c05396dfbe2e189921e0dcfc16d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f02acfef09d5c406c25f3a219ec2e88579795f66c42d37a73d40ba8c9c06404"
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
