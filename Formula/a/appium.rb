class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-3.2.2.tgz"
  sha256 "6e2d758c1d91e22f0aab9925e9d20725f43f33d988abcce7db330ec7fd275155"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "a2732cc7a0b94710eea7ac0ccd0fbdddfd8f63fa3c07464a91e48b518f531840"
    sha256                               arm64_sequoia: "9164df4aadb6b74deeec37919aa6581f1d8734bda3303942d491b4a7631d95a9"
    sha256                               arm64_sonoma:  "db66acca426b760e17e7be07fa10125c640e687b37434795f81433fd5f778d57"
    sha256                               sonoma:        "2116ba2d51d6a08ec5166c6ee9a71b2735c44371a3f1fb986552e20f15a0c8d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f37a9088358f12806d8e2000ce537b06ed7f1e7d2fdf31b188f90cc79539023b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e58a1212964adf3a66d968ed07cf4254b0d9ebfb1be507904c66cdc1c6c68f90"
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
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.6.0.tgz"
    sha256 "e3029e9581015874cc794771ec9b970be83b12c456ded15cfba9371bddc42569"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.2.0.tgz"
    sha256 "8689bbeb45a3219dfeb5b05a08d000d3b2492e12db02d46c81af0bee5c085fec"
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
