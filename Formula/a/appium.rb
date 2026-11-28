class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-4.0.2.tgz"
  sha256 "7db80d25a2247b276ca8304bcb20659d909c0d74ce9526aedd0d828342e74966"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    manifest_sha256 "e7b61ae07d91bd38180b2c0d2ed2214f6460e911d70094cc7f3c7505275e14ec"
    sha256 cellar: :any_skip_relocation, all: "c6faf46d2820ffce51003df3961678c0eec0ff267c5ad270e36d624cfbe5f496"
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
