class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.28.16.tgz"
  sha256 "1e451ce1049ecf5beed9a0f023d51997c7bd0f9868e85b1dfddb9a5b875d8cbd"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "8a5233fa46da736c781c1add9a84b98b8855929d39d4451f562b00a057789ef3"
    sha256                               arm64_sequoia: "529a95bba1fd34f282409d8134ab61f67161feee1906cc1ae79225d66a3e1efc"
    sha256                               arm64_sonoma:  "5ccdaadcdd9d6a93aba25224fc94401eb5f8f90b3644dc144b0794768018bc73"
    sha256                               sonoma:        "1579af31d6e107e28cd363e6362b88812e3fc5ab247dd26ebec6055c330490ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c3d1cc0fe075202851cd7918541dc32310baff4ef2e5b573ccdb16710db3935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a35f2e3fcdd0cf0f6cab2df75cd75b6d606d44ddd51f462d213b463d9529989a"
  end

  depends_on "node"

  # Backport cli-tool version metadata fix.
  patch do
    url "https://github.com/davila7/claude-code-templates/commit/55b8c382abc412180f2c30c07644c5b2b5d01892.patch?full_index=1"
    sha256 "30cc5661d33eb67dbf1981012c9df873b52006c3929ae9fdd37d1c6b0955c16f"
  end

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    # Remove incompatible pre-built binaries.
    libexec.glob("lib/node_modules/claude-code-templates/node_modules/{bufferutil}/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cct --version")

    output = shell_output("#{bin}/cct --command testing/generate-tests --yes")
    assert_match "Successfully installed 1 components", output
  end
end
