class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.17.1.tgz"
  sha256 "56c7e1056c2a650cf354e9d71c3494c8d23a5586e523d4bf4a29c88e82e20d88"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8d7a68e6017264f345bb7c2fe3f8116b03f8882dfc6663eb3298658ff8f5e33e"
    sha256 cellar: :any,                 arm64_sonoma:  "8d7a68e6017264f345bb7c2fe3f8116b03f8882dfc6663eb3298658ff8f5e33e"
    sha256 cellar: :any,                 arm64_ventura: "8d7a68e6017264f345bb7c2fe3f8116b03f8882dfc6663eb3298658ff8f5e33e"
    sha256                               sonoma:        "0c5e0056a384b78f540293a0008fa79eedb7918d1eac8a1ea1cef64a23900a35"
    sha256                               ventura:       "0c5e0056a384b78f540293a0008fa79eedb7918d1eac8a1ea1cef64a23900a35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d468f98ae06a07cba4268719adde647a2b39209439a4d6f0a653bcfbc4714b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd240452e0d4ae4cdf5fb5350466e172dcfc30f8bbbdb90e4f5ab0e757258518"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *std_npm_args, "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
