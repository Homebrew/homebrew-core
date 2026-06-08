class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-3.5.0.tgz"
  sha256 "2aa143b4de6c76ed2071e316331aae7184916aa2fdcdc4d3647ab3f561d97d3d"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "60a5158cf32d709a607f356d8aefbbab0a4f8b3230004d3c18f3f8d75e668e47"
    sha256               arm64_sequoia: "e4cc36e1d8f1d117e75927d7c2454051d3fa9ce91d51f964afb5cae25df05eca"
    sha256               arm64_sonoma:  "2992e68a0cafbe0b303da4678455ca4a25abebc1556b8d757c8a26c0cfb6ee5a"
    sha256               sonoma:        "28ebd3f216658ba5f07cca2cf9027e441f1b59a506c567929299e2e3b550adff"
    sha256 cellar: :any, arm64_linux:   "5b818a1f88382e49c6d0a144582f6328cbcec188210b3d038e6a3f598dd3c148"
    sha256 cellar: :any, x86_64_linux:  "36ba9161d49dbe83807302f679f01bd96ca75dcde893500a4246b2f7462010f3"
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
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.8.0.tgz"
    sha256 "72528f1a8235a8bc19855e21cc5ae28252c276338afa73887dc7e54515bc76c5"
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
