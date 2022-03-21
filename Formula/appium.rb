require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.22.3.tgz"
  sha256 "74d9fbac66e08d9c3b0fde7f4deaa42e1f070167f0508e2891fad28558147fd6"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "b303fb595cec5f55e6e5d372beb6e39ebf9df55c65bb9564559f3e887d3328a6"
    sha256                               arm64_big_sur:  "4a58eb73615f523e0277444f5ed4f2fb524c6885e6b5a1348c6f191d7f62790d"
    sha256                               monterey:       "ac54199b4ba32708ebc956fd476fedc68146fd609bfc4522955de70de57e974a"
    sha256                               big_sur:        "b8a9bbea0b0f8bff3f13c68650b085d0719da4e4329029cecb1e28451c3b4b2e"
    sha256                               catalina:       "a0340dcfc426b989e9b890a568ff546f3d3b6442cd2db7abdbe36d8b6e16b606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ef58ddfa93e0b6ac0124601ff4e2918ff6cee7a49e187b182463a31e609f09f"
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
