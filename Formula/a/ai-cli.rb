class AiCli < Formula
  desc "Generate images, video, audio, and text from the terminal"
  homepage "https://ai-cli.dev"
  url "https://registry.npmjs.org/ai-cli/-/ai-cli-0.9.1.tgz"
  sha256 "320ec8256adeb287ff0b0782e847a28fea8a2c96baeee4ead668fdb8b7e2018a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0e3470537a8d743d57692a53ca71da6eda056702d6c7719531e840cd8e3ea482"
    sha256 cellar: :any, arm64_tahoe:       "0e3470537a8d743d57692a53ca71da6eda056702d6c7719531e840cd8e3ea482"
    sha256 cellar: :any, arm64_sequoia:     "0e3470537a8d743d57692a53ca71da6eda056702d6c7719531e840cd8e3ea482"
    sha256 cellar: :any, arm64_linux:       "ac03ed60bcf8162b9339b714d7c4a02e753af267ac74cfc00940f38ad52b4dc9"
    sha256 cellar: :any, x86_64_linux:      "967598473b65dacdc08dc7fc763c813183308d76647f078c11ff7103b1b19d40"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/ai text --image #{testpath/"missing.png"} describe 2>&1", 1)
    assert_match "could not read reference image", output
  end
end
