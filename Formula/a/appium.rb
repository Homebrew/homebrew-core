require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.1.0.tgz"
  sha256 "d54df2d166644e544e3b50bb7d570db712009d3c54d4aa1c9401908289a0c7ff"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "52a9cdac20f2cfc3a80c2d537d893baa3c9de1dfa95bd6402c312343ceb615a7"
    sha256                               arm64_monterey: "60f21fd15ad8b65b0fb38f2ace227ae49c63ce8369a8cfc93747fa012396cf52"
    sha256                               arm64_big_sur:  "1bfb68e837a8232d2cddf4afcd177437289e1e64c012cfa26d14e456b64d09e7"
    sha256                               ventura:        "9aafb831b2cf2f5d81ee11eef5ee204ec0e78ca4bdc02d94cc350b9fed1d84ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "350a3b834c225e3b8901f8e21388f8df94f8da98832f5e5965094f920d6ea5c1"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

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
    assert_match version.to_s, shell_output("#{bin}/appium --version")

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
