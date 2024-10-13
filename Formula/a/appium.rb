class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.11.5.tgz"
  sha256 "dce25417dcda0a199b065376b499f99db56ebbd2b5ac05b26d8940404a6b438e"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cc04b1f65472bd7db69f603d387bf147bedc1df649a14ecf1fb7b8ba41cabf50"
    sha256 cellar: :any,                 arm64_sonoma:  "cc04b1f65472bd7db69f603d387bf147bedc1df649a14ecf1fb7b8ba41cabf50"
    sha256 cellar: :any,                 arm64_ventura: "cc04b1f65472bd7db69f603d387bf147bedc1df649a14ecf1fb7b8ba41cabf50"
    sha256                               sonoma:        "5acea70e7e0808046fb3e1301d6647e1aeb9bf950867c6cfc4b50ce9f19f12b3"
    sha256                               ventura:       "5acea70e7e0808046fb3e1301d6647e1aeb9bf950867c6cfc4b50ce9f19f12b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4bc9732a1ba1f52727dd1bbd3f5478952b4a773f056f7a05c64b4338083701e"
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
