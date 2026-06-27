class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.17.10.tgz"
  sha256 "55213528242c373b3772a04b37ac031e928b96807111f7a6f65869675fa30daa"
  license "MIT"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "4a1f34ef60590a02f899c3eed7ce650dc220220f87446d9f53450246ecc66086"
    sha256                               arm64_sequoia: "4a1f34ef60590a02f899c3eed7ce650dc220220f87446d9f53450246ecc66086"
    sha256                               arm64_sonoma:  "4a1f34ef60590a02f899c3eed7ce650dc220220f87446d9f53450246ecc66086"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c2889004e0e489e26c7192dc74a5c7c75997a9ecd51fbf873037f5819294ba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fb4569ae37a2e6eb9e9c15039ad3c523fcb07fc91e36d887b53a190647a5d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b96967328fb2e9869343be2d7ff24b830d40b85ea28d15490b22652656aaaaf"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end

    generate_completions_from_executable(bin/"opencode", "completion", shell_parameter_format: :none, shells: [:zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
