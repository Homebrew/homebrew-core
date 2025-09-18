class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.9.12.tgz"
  sha256 "215d974acdff606e2e201d09a26f9df1b44c8218ecffdbad8be6232ba2f8947c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b8676a3c7bb560d6587848718d3053937cb647b946e09f30969f806acbbdd4eb"
    sha256                               arm64_sequoia: "b8676a3c7bb560d6587848718d3053937cb647b946e09f30969f806acbbdd4eb"
    sha256                               arm64_sonoma:  "b8676a3c7bb560d6587848718d3053937cb647b946e09f30969f806acbbdd4eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b88837b512fde97b1289a12c35396d5fd0e300d0e1938423918a101b9a4749a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e3752479059b7363657846a1ae1a7c18ce2a15f3450f96502f57c1fe6dd5cde"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
