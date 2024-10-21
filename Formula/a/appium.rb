class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.12.0.tgz"
  sha256 "c47f5d04814484b3f9f6c13a98e27b1795681962054d0ddc40d2565444b524d2"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9cd65391172100776f375871e1355f572e950e151a95a5bfb098a802b03b6722"
    sha256 cellar: :any,                 arm64_sonoma:  "9cd65391172100776f375871e1355f572e950e151a95a5bfb098a802b03b6722"
    sha256 cellar: :any,                 arm64_ventura: "9cd65391172100776f375871e1355f572e950e151a95a5bfb098a802b03b6722"
    sha256                               sonoma:        "abd46bf9f3f3ce051187a6c682331fd61f17f178c55aa4b9cf8aac8ebccc9fd8"
    sha256                               ventura:       "abd46bf9f3f3ce051187a6c682331fd61f17f178c55aa4b9cf8aac8ebccc9fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdc05b2f1ecfd4ec2b9276bfa99d57957876d23606aaba5f80e7d17e48007440"
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
