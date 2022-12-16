require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.9.1.tgz"
  sha256 "13643c2c29fa4b5c7293161b42fed27112b51e0f7f315f9cbece40fbf37ff45b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "850f52a2c1187318a8c7fa56095d81a53bb359d6189598487be808329d45e874"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d06aeff370ef6490d8367100f8bc6e0c2d47c87d1603afc3fb6c21cd3fec5387"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ce48c164de460341a0f9ce69ec2c705c7bfd77454df11f487a24cec01b23679"
    sha256 cellar: :any_skip_relocation, ventura:        "8e1040d6e480ad930b247fd7bd61cc9cc505a04c6782c859e5c592c2c4f4a94b"
    sha256 cellar: :any_skip_relocation, monterey:       "79319a53f0fa3972d5b9546d264a754a2c551d543fb69f93d3aaa783504f47d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "81fb68ea2de2177b93e13f44f51691d6a47e6973509a0b721a15008d9f7d46b5"
  end

  depends_on "bash" => :build
  depends_on "python@3.10" => :build
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
