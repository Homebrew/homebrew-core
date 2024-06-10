require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.9.0.tgz"
  sha256 "b0752f5e3d1004391afe2cf2b38dbfd7710df67793718d3cf47176f15ff5340c"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "22f02438f32bee0c373508aeb1deeda8cc319b47f250bbfd3e83024bff27fd89"
    sha256 cellar: :any,                 arm64_ventura:  "22f02438f32bee0c373508aeb1deeda8cc319b47f250bbfd3e83024bff27fd89"
    sha256 cellar: :any,                 arm64_monterey: "22f02438f32bee0c373508aeb1deeda8cc319b47f250bbfd3e83024bff27fd89"
    sha256 cellar: :any,                 sonoma:         "599dfa851ef7ac0524f7e5643d01c572ea251ad468b64ffb8998d8b3aa3f4031"
    sha256 cellar: :any,                 ventura:        "599dfa851ef7ac0524f7e5643d01c572ea251ad468b64ffb8998d8b3aa3f4031"
    sha256 cellar: :any,                 monterey:       "599dfa851ef7ac0524f7e5643d01c572ea251ad468b64ffb8998d8b3aa3f4031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd8bc91475f6462117fd305b4929f935329bf66b06ec68538b6af16e50ab3fa7"
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
