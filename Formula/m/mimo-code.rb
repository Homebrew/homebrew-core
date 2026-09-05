class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.14.tgz"
  sha256 "52061df13851178b9d2a14a70809f77a1dafd03b3b39887413a5976967749b37"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d2f9ebf4feee7b6fe206969d7eeacb83dda3db54caf27815e1cfef80746a8a37"
    sha256                               arm64_sequoia: "d2f9ebf4feee7b6fe206969d7eeacb83dda3db54caf27815e1cfef80746a8a37"
    sha256                               arm64_sonoma:  "d2f9ebf4feee7b6fe206969d7eeacb83dda3db54caf27815e1cfef80746a8a37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f1cf3d4d1c9379389fd8b9d0a670a153c17c04ef64f0cd103e255ce5400b66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1067b5c59d749b1ff54779df04abeecf7e3fb491c660645923b6ef624904e495"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/@mimo-ai/cli/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "mimocode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mimo --version")
    assert_match "mimo", shell_output("#{bin}/mimo models")
  end
end
