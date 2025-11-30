class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.122.tgz"
  sha256 "09ca2aec893f7a86a8a050642961d618787cb855fcbf4b2a4582df8bee09e9b7"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fcd32395f8f535698ba57937b2e33e6d41607c7aacfb124a96f7700e5320722c"
    sha256                               arm64_sequoia: "fcd32395f8f535698ba57937b2e33e6d41607c7aacfb124a96f7700e5320722c"
    sha256                               arm64_sonoma:  "fcd32395f8f535698ba57937b2e33e6d41607c7aacfb124a96f7700e5320722c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0270b3a6e696ca3a3c7a81f2df911ceaf29b6a09fe6bbf42b590a3c8dd77f958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33a8a1b22fe72151f531422f336b74def88840bf6dac22aaa74f48a5b91d9b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f236a77bfc297962c7d60245e315a689abc54d23ba5e225a23da35712987629e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
