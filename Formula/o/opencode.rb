class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.18.20.tgz"
  sha256 "d7af626824cab417d9c5c12e5c0187e506f1c903ea93bd8e4b1615be16305d2a"
  license "MIT"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "a9dc7628cd613d1a1c94b42256b0b450af438c0f9c9132651b363fbe14a4f730"
    sha256                               arm64_sequoia: "a9dc7628cd613d1a1c94b42256b0b450af438c0f9c9132651b363fbe14a4f730"
    sha256                               arm64_sonoma:  "a9dc7628cd613d1a1c94b42256b0b450af438c0f9c9132651b363fbe14a4f730"
    sha256 cellar: :any_skip_relocation, sonoma:        "1874884dee4b0c59100926a2061596b806cbeeff2f2f2e9c1b27b8b6c258ea6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cdd02b79694885c40f941342c971223076735c4e28887af9a37ec8bd8ba7b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df13fb71d73abeba66fb514e9f806bda22bbd831c8e66920f16a24d2271c1763"
  end

  depends_on "node"
  depends_on "ripgrep"

  # Downloads dependencies in build
  allow_network_access! :build

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
