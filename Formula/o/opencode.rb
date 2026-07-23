class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.18.0.tgz"
  sha256 "c230764b9fc652a334b22e07c4320fce53550870203626b51e76e9cb54089682"
  license "MIT"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "0a3fcea52536bce9dd4544264cb79599953f360b729ed5ad5aa60349577fafc7"
    sha256                               arm64_sequoia: "0a3fcea52536bce9dd4544264cb79599953f360b729ed5ad5aa60349577fafc7"
    sha256                               arm64_sonoma:  "0a3fcea52536bce9dd4544264cb79599953f360b729ed5ad5aa60349577fafc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7af76ab4e7e5225de7d04ce4daed2f19e8cfdc0b847b1919578d10555aebcdca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "269fc466ed8ee1734dee1f43809d4f194208b9a7e854579b537b1b24bcd9ef2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8959bb131492f9c3afb0e379a154e135b0377cedc4a6a7e310c753394ef66e56"
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
