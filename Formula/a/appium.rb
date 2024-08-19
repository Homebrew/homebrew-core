class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.11.3.tgz"
  sha256 "3669eb5a6664ec4dbfa112728045df15fb8eb37025940250f03fe113684a9737"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ff904d73fcd61de42bda6af4d4c14e29d55d333d2caeab46c8969fba20600570"
    sha256 cellar: :any,                 arm64_ventura:  "ff904d73fcd61de42bda6af4d4c14e29d55d333d2caeab46c8969fba20600570"
    sha256 cellar: :any,                 arm64_monterey: "ff904d73fcd61de42bda6af4d4c14e29d55d333d2caeab46c8969fba20600570"
    sha256 cellar: :any,                 sonoma:         "6d74636410776173b899b38dcf075e2d670b84ca63b61e32d21979643db5d52b"
    sha256 cellar: :any,                 ventura:        "6d74636410776173b899b38dcf075e2d670b84ca63b61e32d21979643db5d52b"
    sha256 cellar: :any,                 monterey:       "6d74636410776173b899b38dcf075e2d670b84ca63b61e32d21979643db5d52b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e20c7c7dcad11579065b5761bd248ac63e0ff6c5b1f36d5321754fe4cbd4e8ca"
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
