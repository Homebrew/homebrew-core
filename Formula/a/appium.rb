class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-3.3.1.tgz"
  sha256 "bbc40faf599751b424316dea59268b302f6c9e14702f4e78679ca4a1ca75ac74"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "a7fbad3b9079cac71d751aad6b42f1d89cae90a45a8f86520ee06a28257e2c7b"
    sha256                               arm64_sequoia: "d9b9f1669affe0f7cc0468f8103f6397c8ff8837eee5f7e58757ee8c03341f0c"
    sha256                               arm64_sonoma:  "284eba00f8277938eeefbd9f7d02a7324a3508f47e4d2a9e2c64d8175638f011"
    sha256                               sonoma:        "d9aec8d82d9deae2e4c359a8a39c456743312f2df51d9ec8a0ab16fecf6978a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3088fa14162887536bf44375bd5a6498a4dd11e5f68ea2556601016ee8f80bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acc2aae8201a73e49b0b9b4c9f9782f4d2ee3b31ced19429718411250c5242c3"
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
