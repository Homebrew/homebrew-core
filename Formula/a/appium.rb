require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.3.0.tgz"
  sha256 "8ec454c9c60fa3b06b2ca1f47aea7be5c6b8566520347596dea51632ee238867"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "e3f3ab5679a0504ae118a3a99f99beec59186a3ff9f24d95fe3b73079b123d6b"
    sha256                               arm64_ventura:  "fe4ac2c668870751e384683ef00dcba02cc04a17a626eb5d3d01a22fcfa808bd"
    sha256                               arm64_monterey: "0d7b2172b68228e66ba1ad0da5353f5eb617af49e0229ea767216a9917076e3f"
    sha256                               sonoma:         "9ca04094255b63a095fb60a38bf1eba91a1b5af8b28f2ed7e693885bab835d4f"
    sha256                               ventura:        "7283a99272d77f304953da831c75254760a59a5bbd407a3b7dfa98656e66dcd2"
    sha256                               monterey:       "f06a88d042ea5670858ec48df8e33865f72e66d4d98e36b4a971844b1ce2ba66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "902d30cd4dd20c6935cc026604c7301a68eb51c24b3c33f514d89751a4fb5c89"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete obsolete module appium-ios-driver, which installs universal binaries
    rm_rf libexec/"lib/node_modules/appium/node_modules/appium-ios-driver"

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
