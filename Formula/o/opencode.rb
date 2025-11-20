class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.81.tgz"
  sha256 "4198e9a7c84a103cf843904dae7dace4f34e4ecfeb540d79c335bcf339680d92"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "05f913356db325758b5e5d462c5fba3ccd1bf8058bc51873854ecfce1e555af1"
    sha256                               arm64_sequoia: "05f913356db325758b5e5d462c5fba3ccd1bf8058bc51873854ecfce1e555af1"
    sha256                               arm64_sonoma:  "05f913356db325758b5e5d462c5fba3ccd1bf8058bc51873854ecfce1e555af1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1170ed6d32846e63c54cc7d127a873f00765bf1335e9ec4040a0280b70b19f6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97c0216444a1ace660cdaf269a697b3333006f7baa7f32c4ebe9f6ed32fdefb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "060f359ddd8d0984a713093b196f00e64be563c8d77463447f382a9caad6efc1"
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
