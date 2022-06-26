require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.22.3.tgz"
  sha256 "74d9fbac66e08d9c3b0fde7f4deaa42e1f070167f0508e2891fad28558147fd6"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "5b71cfdfa29c2bc98785b485fc0b279753125d9af2e9bf9bbc5e4d7f8d9ce4f8"
    sha256                               arm64_big_sur:  "e2f7fdf6d4c72380fd43936143660911c408b98542d0e033b3a2cbb20d6e1fab"
    sha256                               monterey:       "854d9cf2275384e65781c8201af16f3a6ce0ddea25fb0f12d2999fc09438c018"
    sha256                               big_sur:        "698fe344433d98af374558688ea665921fb7d74f09c51ac61d5739fb0fcc467a"
    sha256                               catalina:       "9fd553fc9f5957b5cd8bc1c1892fcb9dfcff89571dfe8af04a70c752a0641a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b231d0004b0f8d6bb85da28e0d5181c496ee38b015a1bcbff992c49d24c851f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete obsolete module appium-ios-driver, which installs universal binaries
    rm_rf libexec/"lib/node_modules/appium/node_modules/appium-ios-driver"

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  service do
    run opt_bin/"appium"
    environment_variables PATH: std_service_path_env
    keep_alive true
    error_log_path var/"log/appium-error.log"
    log_path var/"log/appium.log"
    working_dir var
  end

  test do
    output = shell_output("#{bin}/appium --show-config 2>&1")
    assert_match version.to_str, output

    port = free_port
    begin
      pid = fork do
        exec bin/"appium --port #{port} &>appium-start.out"
      end
      sleep 3

      assert_match "unknown command", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
