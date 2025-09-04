class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.2.tgz"
  sha256 "da606b141a6a4d315f4b4d2f74222b510d8c5b4065b329f5ba5adf861253797a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8793dddea3db91d1c97192629b85e89e7d8ca9d1849050e1f03e0a919af30f21"
    sha256 cellar: :any,                 arm64_sonoma:  "b27a5ab9b7d5a4063a1877a35eb8a63255c8728260a9053f50de7d763a520144"
    sha256 cellar: :any,                 arm64_ventura: "5bc0b1ce6799117fa638651d6cede038950175d6ede44378a05426da8051179b"
    sha256 cellar: :any,                 sonoma:        "69efd76fd76a206c228a1b8a7f237280c760ba281d8f06374ce0498987a32848"
    sha256 cellar: :any,                 ventura:       "9bb8d6ed90669b798e159336a863654ec0c61149543f692191bcdf7d9726f2f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf0d3b80e337b8fc7ad81df400d8a3dfdd76020c18d1bd4d9263ae6e09a3e76e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a406eec62625ca12e0db44e625e1410905ddb67d99d48e0693e54fc0907cddf1"
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
