class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://www.dicebear.com"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.7.0.tgz"
  sha256 "9fef906a168742230b3a31e90bd0708a555a7a14d06c6ebd8d13e368d3336902"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b1621a2a0b1c585bc02e4a57c24b20987bfb25b23d0334dc1fca2bb5c4f9aef7"
    sha256 cellar: :any, arm64_tahoe:       "d626552a199dc6136d4551f129b10dfd60308e56a800add1345d9b9a78467075"
    sha256 cellar: :any, arm64_sequoia:     "f691b220e0fa1b105c8c7b1f41ac8877f45fc42b5c131f85a78ecf80db1b846f"
    sha256 cellar: :any, arm64_sonoma:      "ebd67b893a2e6c084328e5f06014d3f515ddf6330712d551906e0d2316ed6790"
    sha256 cellar: :any, arm64_linux:       "ee4992c3ea57a9787ccc927af2d9ec097c81092b06a0d186d4a4a45bfe8568fa"
    sha256 cellar: :any, x86_64_linux:      "69e77077274a8b6c499cf39570568d8f5b3f95ad07ddaeb39ece407deaf1a16a"
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
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.2.tgz"
    sha256 "4cd65698541b19a33f798f1dc25c02c6ed1c9d7749b8824b1a1ccecdd197c8ea"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.2.tgz"
    sha256 "1b1524d914331bd01312729e31a828192d53af84e113dacb6e36afabb6c21a6d"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilts which still get installed as optional dependencies
    node_modules = libexec/"lib/node_modules/dicebear/node_modules"
    rm_r(node_modules.glob("@img/sharp-*"))
    cd(node_modules/"sharp") { system "npm", "run", "build" }
  end

  test do
    output = shell_output("#{bin}/dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_path_exists testpath/"avataaars-0.svg"

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/dicebear/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = formula_opt_lib("vips")/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end
