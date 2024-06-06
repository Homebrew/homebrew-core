require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.7.0.tgz"
  sha256 "1ac389b8c44789e7c5db49e8d0203bb99531b1d4ef09821bb35e31f19b53c7cd"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "35f04b14c41b303320fbc11e8eb8c9d222be0afbab5f1139efe79df34af944d3"
    sha256 cellar: :any,                 arm64_ventura:  "35f04b14c41b303320fbc11e8eb8c9d222be0afbab5f1139efe79df34af944d3"
    sha256 cellar: :any,                 arm64_monterey: "35f04b14c41b303320fbc11e8eb8c9d222be0afbab5f1139efe79df34af944d3"
    sha256 cellar: :any,                 sonoma:         "f402db980dcacef622780b6e427241138b12bec1970be5f37a49f761648a1ac8"
    sha256 cellar: :any,                 ventura:        "f402db980dcacef622780b6e427241138b12bec1970be5f37a49f761648a1ac8"
    sha256 cellar: :any,                 monterey:       "f402db980dcacef622780b6e427241138b12bec1970be5f37a49f761648a1ac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a28c553a53ef43f194c188d68eb55bf3e6042fff08faf1dc730d016ae752190c"
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
