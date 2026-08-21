class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.18.15.tgz"
  sha256 "aae2e10aa53da715d097ac109ca03c0feb451bd453dce9d21d335c6fc7a37c0a"
  license "MIT"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "4515cb503a7889c18ffbe553e60d4505fa3601700c3639628c286eb5246d4bc0"
    sha256                               arm64_sequoia: "4515cb503a7889c18ffbe553e60d4505fa3601700c3639628c286eb5246d4bc0"
    sha256                               arm64_sonoma:  "4515cb503a7889c18ffbe553e60d4505fa3601700c3639628c286eb5246d4bc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6960e26caf2792b784778bfe76026e06da449d5ece80252680b33d393b1550c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d7bdec3380775e4fa18a67f897378c0f6c8e877868e9debd4518ecc1d60ef7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "647ab92c4a4615d34638faa4e805a344b8f19f522d736e763f8e6443e8745a94"
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
