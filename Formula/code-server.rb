require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.12.0.tgz"
  sha256 "3044a0db2a8961736473b0a015c95f707708ad1af10258d2df9b996542bd20f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bf5bc2424a3350b91b22113069ec0b6bd3aedb0f0e01171836fade7b8c81f87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d57d4ab6c192d8ca1df1e22ea050e4067934a7c7b7c78d5d58e2b021df3d0bbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a938a8c0469a9b2f9b5c00b06a9ed71b817fa46844e16e30bec3f90db1441bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "873bf46668b4b748885412b9cd1968217a73fb50ca81e6923369c34386cd0c7f"
    sha256 cellar: :any_skip_relocation, monterey:       "c7a1f11f4aa3938678c0c7d17cde23bce22fb55cbc96a2958c5d241f8ad9b4ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "81b519a09cd98929875d2e701f553e6935ba2296ce7899e4803332e2dcdd9234"
  end

  depends_on "bash" => :build
  depends_on "python@3.11" => :build
  depends_on "yarn" => :build
  depends_on "node@16"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    node = Formula["node@16"]
    system "npm", "install", *Language::Node.local_npm_install_args, "--unsafe-perm", "--omit", "dev"
    # @parcel/watcher bundles all binaries for other platforms & architectures
    # This deletes the non-matching architecture otherwise brew audit will complain.
    prebuilds = buildpath/"lib/vscode/node_modules/@parcel/watcher/prebuilds"
    (prebuilds/"darwin-x64").rmtree if Hardware::CPU.arm?
    (prebuilds/"darwin-arm64").rmtree if Hardware::CPU.intel?
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
    working_dir Dir.home
  end

  test do
    # See https://github.com/cdr/code-server/blob/main/ci/build/test-standalone-release.sh
    system bin/"code-server", "--extensions-dir=.", "--install-extension", "wesbos.theme-cobalt2"
    assert_match "wesbos.theme-cobalt2",
      shell_output("#{bin}/code-server --extensions-dir=. --list-extensions")
  end
end
