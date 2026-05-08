class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-3.4.0.tgz"
  sha256 "05b211a4d859f8ac381f6363eb80deefbb70775cbeab67749c72ea9aa8e5cf5c"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "9e52821843b32a9ede2a5e745f0e67ec67ce059376c3f96ba8b056a17d387360"
    sha256                               arm64_sequoia: "3512a82ce2e7b808496b338e211ecd575ed861ae8d29723e003535ef865dac41"
    sha256                               arm64_sonoma:  "041888f44a8500b609039110308590b901a5b1cca5f9f6efd6baec9029910489"
    sha256                               sonoma:        "e2cc4ce699961844f702baf6b2178a692ab535605674c7b454cb112e1bcc9227"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f1837f1a37943da5c3670e97f9cd2608ffbcac0eb8fd1e9e089325dd6f79951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a35512be44667f7b3308dba055d9a41e339b7283570cedf09e5ef7bb0eacb89"
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
