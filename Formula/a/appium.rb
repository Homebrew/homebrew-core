require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.10.3.tgz"
  sha256 "8a8bf24feba47656a557cc77d7ab1a32986bff6ee08283fb5184f271a261765e"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "072d300c837f7ddd4b9eb401564f760dbd7a5b410a302bf41cfc5d39b1094435"
    sha256 cellar: :any,                 arm64_ventura:  "072d300c837f7ddd4b9eb401564f760dbd7a5b410a302bf41cfc5d39b1094435"
    sha256 cellar: :any,                 arm64_monterey: "072d300c837f7ddd4b9eb401564f760dbd7a5b410a302bf41cfc5d39b1094435"
    sha256 cellar: :any,                 sonoma:         "dab8519ccda87ccaa0b46f5f89ae124c4f40f8e906485b29e422fdcd61f79c16"
    sha256 cellar: :any,                 ventura:        "dab8519ccda87ccaa0b46f5f89ae124c4f40f8e906485b29e422fdcd61f79c16"
    sha256 cellar: :any,                 monterey:       "dab8519ccda87ccaa0b46f5f89ae124c4f40f8e906485b29e422fdcd61f79c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c91109185cdb5db96db0f29e423c94d0295af1f8d219eab89865a2e7ccfcb6a5"
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
