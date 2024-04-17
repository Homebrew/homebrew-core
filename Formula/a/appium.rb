require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.5.3.tgz"
  sha256 "dbeecb8d51e2f11ec742a0a77d54165d00bf0a110ab32f5048a4453990df1f65"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0de964c7d7b70f2286c7875b8e42826a745af7704d45dc2fbbb609893168ad2e"
    sha256 cellar: :any,                 arm64_ventura:  "0de964c7d7b70f2286c7875b8e42826a745af7704d45dc2fbbb609893168ad2e"
    sha256 cellar: :any,                 arm64_monterey: "0de964c7d7b70f2286c7875b8e42826a745af7704d45dc2fbbb609893168ad2e"
    sha256 cellar: :any,                 sonoma:         "ec87e8f2a18cd1753034b1e71c78ac4efdef99518f593f48f4700ec7b79cffa2"
    sha256 cellar: :any,                 ventura:        "ec87e8f2a18cd1753034b1e71c78ac4efdef99518f593f48f4700ec7b79cffa2"
    sha256 cellar: :any,                 monterey:       "ec87e8f2a18cd1753034b1e71c78ac4efdef99518f593f48f4700ec7b79cffa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5f8b533cf44f73faa4539e30199403c3f723c4b00e76c1233b1b5f9aa999f6f"
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
