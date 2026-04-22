class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.4.10.tgz"
  sha256 "0e1cb037f8eb9176e6ebed94bd725a5516176c393eaa3840ed52bc8bfea59a64"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "471c71bd722e3de4623beb1bac8c40fb4a179890eeea71a75f43ef88ac2cce49"
    sha256                               arm64_sequoia: "471c71bd722e3de4623beb1bac8c40fb4a179890eeea71a75f43ef88ac2cce49"
    sha256                               arm64_sonoma:  "471c71bd722e3de4623beb1bac8c40fb4a179890eeea71a75f43ef88ac2cce49"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f6838b98a43e71b99bfdfa648f7062344800974eae922c298feb820d60c12d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e21e371df1a349ec1db1afd0b17389f2d81d41bb0698e5cde8d2c7909a86ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8820779759572cd45a8073e703bfaa24e312eaafebc5ffcc9bf373164193bc84"
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
