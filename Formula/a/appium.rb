class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.15.0.tgz"
  sha256 "1127f622768d070c20491516870640325854dd6253f870d679934b5e22f86aca"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "55d243c70467d5d2c377304d27ac9f974881be9200c8ca2d433ab3a7db79dd61"
    sha256 cellar: :any,                 arm64_sonoma:  "55d243c70467d5d2c377304d27ac9f974881be9200c8ca2d433ab3a7db79dd61"
    sha256 cellar: :any,                 arm64_ventura: "55d243c70467d5d2c377304d27ac9f974881be9200c8ca2d433ab3a7db79dd61"
    sha256                               sonoma:        "d2353825f8875a22ef7d85f02c4426d58df5927aebc78e08db3c0c983e14bf20"
    sha256                               ventura:       "d2353825f8875a22ef7d85f02c4426d58df5927aebc78e08db3c0c983e14bf20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47beebdd78a0334d7a944ed8d80b2af2da94314acfba2af83ae3e638061a3c11"
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
