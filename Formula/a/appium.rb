class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-4.0.0.tgz"
  sha256 "9edb822db5aa25d966e32ceaeba210aa64b25adeb2cd255cc0771b0060abf4ad"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "23e51546a450d3e0f4f8a28f65d596ca23bffc68652d6b665d8080c722f19576"
    sha256 cellar: :any, arm64_tahoe:       "ae69961ac2cd2e31df8fd9316d28a54cd0a59ef91dcf7aa971d4173373294e02"
    sha256 cellar: :any, arm64_sequoia:     "0138956ee0a71a93f5e42a48028ee8a9bda6387824a97a166b1c73755f976df9"
    sha256 cellar: :any, arm64_linux:       "f9d45d37761f3b1fb68c539fdb4abd539b3184687bac9e3c284fa735f65e3e1b"
    sha256 cellar: :any, x86_64_linux:      "c6199c4359d159d208062a25c749a2219a461fe877170e5b88611eec7541840b"
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
