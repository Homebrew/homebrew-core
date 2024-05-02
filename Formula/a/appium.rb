require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.5.4.tgz"
  sha256 "c914336f413d81b14c8e0f6e93d01e3c50af77a4bd34268282982b1872cfb36c"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f70ef8ce550c14bab6f6d987c942138c816d2b99b913544729953872cf7e593b"
    sha256 cellar: :any,                 arm64_ventura:  "f70ef8ce550c14bab6f6d987c942138c816d2b99b913544729953872cf7e593b"
    sha256 cellar: :any,                 arm64_monterey: "f70ef8ce550c14bab6f6d987c942138c816d2b99b913544729953872cf7e593b"
    sha256 cellar: :any,                 sonoma:         "cd1cd66afa239170d1f1a740345628cf79e8d43b76540f07363b2210ab58a48b"
    sha256 cellar: :any,                 ventura:        "cd1cd66afa239170d1f1a740345628cf79e8d43b76540f07363b2210ab58a48b"
    sha256 cellar: :any,                 monterey:       "cd1cd66afa239170d1f1a740345628cf79e8d43b76540f07363b2210ab58a48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfcc83d987db413d3f7aef79553508872b3df52b4a77f91f42c55f4781dfb277"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--chromedriver-skip-install"
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
