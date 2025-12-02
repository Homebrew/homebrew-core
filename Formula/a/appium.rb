class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-3.1.1.tgz"
  sha256 "dfdbfa84113a6617810b32e96e6136fe059d845f84cc4d1f1d9ae89d7ac9e1b0"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "0f14dd5b604d36df30426ca7a14eae9a7aff9ab9f6a5b766194f8e42a4043733"
    sha256                               arm64_sequoia: "91fbf9d1b3251dac5bb3c20c5f5b9853ab1251f179cfda9ec56a868d57124bf8"
    sha256                               arm64_sonoma:  "9cb71caa45503e2091abe3722d346870e12501e768049ca3ca768b8c3080b543"
    sha256                               sonoma:        "0f774625519b44f2647fd5406c6f6f66240539ac99a1b9975c0ae9cf8c62c09b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b490ecf71855a6a4cd97b8c62072c9dd18f6bd2bdba3861639b360faac1ba4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39b3bc40472e637d9d396bef264bcad296dbc0de19391d22a89e6d54c2c02780"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.5.0.tgz"
    sha256 "d12f07c8162283b6213551855f1da8dac162331374629830b5e640f130f07910"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.0.0.tgz"
    sha256 "bbe606e43a53869933de6129c5158e9b67e43952bc769986bcd877070e85fd1c"
  end

  def install
    ENV["APPIUM_SKIP_CHROMEDRIVER_INSTALL"] = "1"
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    resources.each do |r|
      system "npm", "install", *std_npm_args(prefix: false), r.cached_download
    end

    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove prebuilts which still get installed as optional dependencies
    rm_r(libexec.glob("lib/node_modules/appium/node_modules/@img/sharp-*"))
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

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/appium/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = Formula["vips"].opt_lib/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end
