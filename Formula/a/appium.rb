class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.18.0.tgz"
  sha256 "a71d89265478e46082d313314296e5285d3cf35a47ac5f189303f2341e882540"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9f51b6873ea1f0a238086d1dce9618f0270c959ebb206bddcf64c4f4cea3b9a"
    sha256 cellar: :any,                 arm64_sonoma:  "d9f51b6873ea1f0a238086d1dce9618f0270c959ebb206bddcf64c4f4cea3b9a"
    sha256 cellar: :any,                 arm64_ventura: "d9f51b6873ea1f0a238086d1dce9618f0270c959ebb206bddcf64c4f4cea3b9a"
    sha256                               sonoma:        "ada43312361db2dbe53846eb7043b5f74057bca45c685322d47cb86aa8aef605"
    sha256                               ventura:       "ada43312361db2dbe53846eb7043b5f74057bca45c685322d47cb86aa8aef605"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20406e44f2db15b318f348e9bbb4c5804db91ddf3e42ec05af3633256d64e405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8e036d97e585075cae1bd0f22829f244d8324a29768735ccade67183d1eadb6"
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
