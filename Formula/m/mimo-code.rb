class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.7.tgz"
  sha256 "a1f1df1725976021d584ea0d44c86ae8caeffe2bd900770b3c30a61303839c3d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "7ed86b63a622e0c4842464db5696cf9b23791120311ae4f4bb7ccb8f308bbbf8"
    sha256                               arm64_sequoia: "7ed86b63a622e0c4842464db5696cf9b23791120311ae4f4bb7ccb8f308bbbf8"
    sha256                               arm64_sonoma:  "7ed86b63a622e0c4842464db5696cf9b23791120311ae4f4bb7ccb8f308bbbf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c2df08f9df16fe8f2320f8433115e0ee621daa875811c6436d3e05ccd44a3d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3af463a32a7514bcba11c1936b4ab5f0df23829574006858dab79328d088e045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e64e7c24d86c27c457c88516064e103dddaf09282a8af26f2fb3e7b9d98fbac8"
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
