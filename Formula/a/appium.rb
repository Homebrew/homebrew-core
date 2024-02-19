require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.5.1.tgz"
  sha256 "b7b49d2c307b8b4db49f8a004d9b76a5441662b19b8cfb191f542f51ba65cf53"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "43ccfe10dc211fdedd81baee0b9faf21d3fed12edd95e61ae1bd85f83196eee1"
    sha256 cellar: :any,                 arm64_ventura:  "43ccfe10dc211fdedd81baee0b9faf21d3fed12edd95e61ae1bd85f83196eee1"
    sha256 cellar: :any,                 arm64_monterey: "43ccfe10dc211fdedd81baee0b9faf21d3fed12edd95e61ae1bd85f83196eee1"
    sha256 cellar: :any,                 sonoma:         "98f6cd9b2360df0cfac7f742b07e9a6da4dbb77743555b150de377065e20ada3"
    sha256 cellar: :any,                 ventura:        "98f6cd9b2360df0cfac7f742b07e9a6da4dbb77743555b150de377065e20ada3"
    sha256 cellar: :any,                 monterey:       "98f6cd9b2360df0cfac7f742b07e9a6da4dbb77743555b150de377065e20ada3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77792d8a31ca6106ae8fc4e8125dbc6759d2eec9ce58d4d64d9fd7b7be8307c9"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    if OS.linux?
      node_modules = libexec/"lib/node_modules/appium/node_modules"
      (node_modules/"@img/sharp-libvips-linuxmusl-x64/lib/libvips-cpp.so.42").unlink
      (node_modules/"@img/sharp-linuxmusl-x64/lib/sharp-linuxmusl-x64.node").unlink
    end

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
    output = shell_output("#{bin}/appium server --show-build-info")
    assert_match version.to_s, JSON.parse(output)["version"]

    output = shell_output("#{bin}/appium driver list 2>&1")
    assert_match "uiautomator2", output

    output = shell_output("#{bin}/appium plugin list 2>&1")
    assert_match "images", output

    assert_match version.to_s, shell_output("#{bin}/appium --version")
  end
end
