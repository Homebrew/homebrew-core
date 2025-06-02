class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.19.0.tgz"
  sha256 "ab8ab9723dd44d3a0adfa14e4320d9578a9127576f7fb862048d2335c9376f14"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1aa5c5c8334cf4c5b056d2aa930aa8b98de4cef3b2e827eee49a5200f727d093"
    sha256 cellar: :any,                 arm64_sonoma:  "1aa5c5c8334cf4c5b056d2aa930aa8b98de4cef3b2e827eee49a5200f727d093"
    sha256 cellar: :any,                 arm64_ventura: "1aa5c5c8334cf4c5b056d2aa930aa8b98de4cef3b2e827eee49a5200f727d093"
    sha256                               sonoma:        "8909d3b6daacd319dd44e4e3cf78ca3ad9db35ff0b6ac2cbe82139008413934e"
    sha256                               ventura:       "8909d3b6daacd319dd44e4e3cf78ca3ad9db35ff0b6ac2cbe82139008413934e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dd10a0552bef4be2a6ed07562df92fc68a3d5763c0358b1248a802bb30f450f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67aa078cebb2641bc508bb80435c9f90b87c10fd079ba546f560b4cdfb99c7b3"
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
