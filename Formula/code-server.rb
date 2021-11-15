class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-3.12.0.tgz"
  sha256 "3eb48472d18e54cc708bee2f9f481af84edca69af2bf6ee23824361c3e6eaa85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d88c6df60d41d21f3b33f4e748d5545608a4286bc76493ee1f996509788a314"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b7d277448b9e084e6c34d88a7f3185510cbecddf76afe5e51306551d7947801"
    sha256 cellar: :any_skip_relocation, monterey:       "ee453bf4cc646788b145e20da19aa757dcd0bb3e272ef84c7ed74be62eb83ba4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7abc30a302af569a6887d67aa27c91bdc9a023245d881c57cceb02c6bb73ae3"
    sha256 cellar: :any_skip_relocation, catalina:       "3645e3236d39003f35c00d0772ad619158ab4a024f621f0c06764dcf44030539"
    sha256 cellar: :any_skip_relocation, mojave:         "7ca731bd99f09f23567cbead57850f886bed034036d27ca768b83ec5e889037e"
  end

  depends_on "python@3.9" => :build
  depends_on "yarn" => :build
  depends_on "node@14"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    node = Formula["node@14"]
    system "yarn", "--production", "--frozen-lockfile"
    libexec.install Dir["*"]
    env = { PATH: "#{node.opt_bin}:$PATH" }
    (bin/"code-server").write_env_script "#{libexec}/out/node/entry.js", env
  end

  def caveats
    <<~EOS
      The launchd service runs on http://127.0.0.1:8080. Logs are located at #{var}/log/code-server.log.
    EOS
  end

  service do
    run opt_bin/"code-server"
    keep_alive true
    error_log_path var/"log/code-server.log"
    log_path var/"log/code-server.log"
    working_dir ENV["HOME"]
  end

  test do
    # See https://github.com/cdr/code-server/blob/main/ci/build/test-standalone-release.sh
    system bin/"code-server", "--extensions-dir=.", "--install-extension", "wesbos.theme-cobalt2"
    assert_match "wesbos.theme-cobalt2",
      shell_output("#{bin}/code-server --extensions-dir=. --list-extensions")
  end
end
