class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-3.0.2.tgz"
  sha256 "be83f5ddd80111d60a1ea928b09f9cc6e1713d6ab149e0d4f11d3e933b3959ce"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "51b7272e49c8a5650cd6fc2a70da19cadf3fc5186e2f4998d442e8186740118d"
    sha256 cellar: :any,                 arm64_sequoia: "63cdbafbadf24db7e970654406a039c4d32a453fd6a573d9b12a7cfd9ee6df27"
    sha256 cellar: :any,                 arm64_sonoma:  "63cdbafbadf24db7e970654406a039c4d32a453fd6a573d9b12a7cfd9ee6df27"
    sha256 cellar: :any,                 arm64_ventura: "63cdbafbadf24db7e970654406a039c4d32a453fd6a573d9b12a7cfd9ee6df27"
    sha256 cellar: :any,                 sonoma:        "8a43acc41c10a7251a60c8bd0143e6461b5ec7d566b63df8755e14fb852219e1"
    sha256 cellar: :any,                 ventura:       "8a43acc41c10a7251a60c8bd0143e6461b5ec7d566b63df8755e14fb852219e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed1dcda7c11ac9b86ebc3a4785bfd6db62c3cf34d7fa413a1df1cd1dfc905240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bea9de47acf4f8995d61b49f24478146684df65cb3c385fd092617ec1363831"
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
