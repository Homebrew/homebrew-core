require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.22.1.tgz"
  sha256 "55363cbb8f575a7b7756453b0b814c9f6de9e0648b852b6a0352be059ca11dea"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fbd3e1156183a1f11517e5a5a460254e4d922c205668ab2fc7201151e696291"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fbd3e1156183a1f11517e5a5a460254e4d922c205668ab2fc7201151e696291"
    sha256 cellar: :any_skip_relocation, monterey:       "3ae4a92de2de3e0bed0dfceb58730df421876c5c2c0eae78c453fc7432e29764"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ae4a92de2de3e0bed0dfceb58730df421876c5c2c0eae78c453fc7432e29764"
    sha256 cellar: :any_skip_relocation, catalina:       "3ae4a92de2de3e0bed0dfceb58730df421876c5c2c0eae78c453fc7432e29764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fbd3e1156183a1f11517e5a5a460254e4d922c205668ab2fc7201151e696291"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete obsolete module appium-ios-driver, which installs universal binaries
    rm_rf libexec/"lib/node_modules/appium/node_modules/appium-ios-driver"
  end

  plist_options manual: "appium"

  service do
    run opt_bin/"appium"
    environment_variables PATH: std_service_path_env
    run_type :immediate
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
