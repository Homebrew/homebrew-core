require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.1.3.tgz"
  sha256 "af7a194c89df51986c343adca5d68dfe6b6380d50b393a7d6f93c2491feac624"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "e5cda4e54a7126fe2db09cddc195f7c08593f34d3b5fd54b1394f135120642a7"
    sha256                               arm64_monterey: "9b1f7feb77e006c5953f8339fff2c5f50c1641b90f9c30316c99a7b948a7ebd9"
    sha256                               arm64_big_sur:  "57f9c61ca3fcfd70229350aa07378fa5c24ac6f85a55c279044e13c262a5d76a"
    sha256                               ventura:        "c80f2cf7b7e56b8eebdd7cf953c952a3666958ad49c107bf460d596642479039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a838fd4c51ff7d3ea37566f1616feaf1fc1a9dad7ee8e6ece179190c147da131"
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
