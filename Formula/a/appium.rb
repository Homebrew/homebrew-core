class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-4.0.1.tgz"
  sha256 "4aab952a46fa1966691b41cc8b2623fb3c2187415e335cbeed08dd5fbd9a52ff"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    manifest_sha256 "48f7dfe876ef4f468a729900086a47e24098808c2c55f35e5f7cc888659f2706"
    sha256 cellar: :any_skip_relocation, all: "d2173487c2f9c47d4e78dbce2e7dd9e03e76d6fedcb854b56aaf7f68bdb39248"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    ENV["APPIUM_SKIP_CHROMEDRIVER_INSTALL"] = "1"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appium/node_modules"
    rm_r(node_modules.glob("bare-{buffer,path,fs,os,url}/prebuilds/*"))
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
    output = shell_output("#{bin}/appium server --show-build-info")
    assert_match version.to_s, JSON.parse(output)["version"]

    output = shell_output("#{bin}/appium driver list 2>&1")
    assert_match "uiautomator2", output

    output = shell_output("#{bin}/appium plugin list 2>&1")
    assert_match "images", output

    assert_match version.to_s, shell_output("#{bin}/appium --version")
  end
end
