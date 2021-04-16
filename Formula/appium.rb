require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.20.2.tgz"
  sha256 "a707dc2f21890774b289d87a35caf5e4ca1211d794cbb4daa1b4a82174c6ab43"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "dfdf7b266b87ae1305b59edd974bb6c5c45540f039c1d3ec1fc1a9409ae8e0f4"
    sha256 cellar: :any, big_sur:       "3b1fb101b829a8c4c94a42c452579c7cd90fd48a42fc0d3c0e8af52390312232"
    sha256 cellar: :any, catalina:      "05cec8a15e6974dd917aa41ebf3bd9d5df45fb8f4c0b9d0496775257cb2c91a5"
    sha256 cellar: :any, mojave:        "d3fdc01e23b34d4829f6b1f5d63cbc178448ffdae9a28cca17ca879241b2f63c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
