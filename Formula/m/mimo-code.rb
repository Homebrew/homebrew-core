class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.5.tgz"
  sha256 "1c3df4851a4ae2ae9ed96c0780f49002df71daf9744c8d47bb100990261b4d83"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c69672b8430a6d9445df1855bcdd6e1518431ded148ad2899a984a2652f5cdf1"
    sha256                               arm64_sequoia: "c69672b8430a6d9445df1855bcdd6e1518431ded148ad2899a984a2652f5cdf1"
    sha256                               arm64_sonoma:  "c69672b8430a6d9445df1855bcdd6e1518431ded148ad2899a984a2652f5cdf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c40365dca323b57f9498d1beac90cce56441fc1d34188efa0e98bd0fd2593dec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d549f76defed38ce0dcd328099ad0e5881c049bdfb70204dd338ab44ffecce54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "facf89096b0ae7a94dd95fb7a95edd9ace119e76f8ab4f1a83c88e70bc3168cd"
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
