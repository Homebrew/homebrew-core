class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.17.15.tgz"
  sha256 "ea541bd07c4bdd73d867e4d1ad06635584247c355215068e61c0d15aa9d1ffd3"
  license "MIT"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "db15fad6048b4e15318ea51434159d1fe33d10c5211f49794b70afae4fbe70ce"
    sha256                               arm64_sequoia: "db15fad6048b4e15318ea51434159d1fe33d10c5211f49794b70afae4fbe70ce"
    sha256                               arm64_sonoma:  "db15fad6048b4e15318ea51434159d1fe33d10c5211f49794b70afae4fbe70ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a2c898899bc104114c59b933d2e98266c17ff94fef2fcd9d78d23f703259843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4434b0fab5d328743106ce9e74bb15f4ecd1e31e681be9b1e2182d33d3c8cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe19bb3b40fa6b0a924050112a38b3d4b31a4666e9490a7aa586884a9083d951"
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
