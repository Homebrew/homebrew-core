require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.6.1.tgz"
  sha256 "2ba6e1c8e4bdf9aae76ad6742bd4b9b25b03b08f9718eca163d9fb25e9e594ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bd021747c2bfdfdf8fd47e40b51668da739d44089ffddfe5c767dfeca7f3aa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73526abf599150d45fd87bf6de3f724cbed2fdb756b08e86d2549aa4f808fb99"
    sha256 cellar: :any_skip_relocation, monterey:       "ab37b348f550baa6148320f109c7e6afd9ff4d313e5fe937b07117a1ef1766e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "187924ead946962fea70215097067afc863d7a93a7e48b369b4baec5d91e893f"
    sha256 cellar: :any_skip_relocation, catalina:       "2ae453d7adf5d82f1f5069c333eaa03d1e08a04bea5382d2679a77b43151d697"
  end

  depends_on "bash" => :build
  depends_on "python@3.10" => :build
  depends_on "node@16"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    node = Formula["node@16"]
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--unsafe-perm"
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
