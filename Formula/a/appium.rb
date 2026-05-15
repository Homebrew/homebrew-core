class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-3.4.2.tgz"
  sha256 "632323d86effe1d9b69df5f8e1914e98bc39f6adbaf0378e28fc76a026dfe694"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "7fe2c5732578f22a80f95782f41967b1e18a72d759e9411d53037f29206a0ee5"
    sha256                               arm64_sequoia: "b46e35c483c15816400ee5733676878e816f723281c1782cbcfbd58c38afbd51"
    sha256                               arm64_sonoma:  "8b6741c501e6e8d7adfe8571993801e1c6acfc862037edb50612591e2b9a4cb6"
    sha256                               sonoma:        "d28cb06009d89cb0856cdcb1bdb39935145817930c29d1b5b257cc0f869d39ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0258a0905433eefa1d500ce087a2a9921d5b85043d6edc2eb4ea5d8502d1d0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa51249c93b39227c3a444aa7f9f73e7b9139a1b1f5f4ce41b33fa9725182bc9"
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
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.7.0.tgz"
    sha256 "06cdc368599c65b996003ac5d71fe594a78d3d94fc51600b2085d5a325a3d930"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.3.0.tgz"
    sha256 "d209963f2b21fd5f6fad1f6341897a98fc8fd53025da36b319b92ebd497f6379"
  end

  def install
    ENV["APPIUM_SKIP_CHROMEDRIVER_INSTALL"] = "1"
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilts which still get installed as optional dependencies
    rm_r(libexec.glob("lib/node_modules/appium/node_modules/@img/sharp-*"))
    rm_r(libexec.glob("lib/node_modules/appium/node_modules/bare-{fs,os,url}/prebuilds/*"))
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
