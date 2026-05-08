class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.14.40.tgz"
  sha256 "ed648ca5651e7e82bb7598a7fd475dfa3a29ede83829d5b90b160215012cbd75"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "7dbe93ad0bf2dc924e10c2541d5209cecdc71af93516d653889449f7d389964c"
    sha256                               arm64_sequoia: "7dbe93ad0bf2dc924e10c2541d5209cecdc71af93516d653889449f7d389964c"
    sha256                               arm64_sonoma:  "7dbe93ad0bf2dc924e10c2541d5209cecdc71af93516d653889449f7d389964c"
    sha256 cellar: :any_skip_relocation, sonoma:        "05b6ac0d5c92b22c7154bb3e445789d6e869c147489b47f8db3c5d00771f062f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "886a3839a6b0578ec75fcd218d7f7546e5fe5ed8849fa72566b841b45d898ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e98a8707f4dc2890d4da3892d4c51a485faf7a49028c157f6759134d8b3ab430"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
