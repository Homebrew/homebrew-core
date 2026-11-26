class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://www.dicebear.com"
  url "https://registry.npmjs.org/dicebear/-/dicebear-11.0.0.tgz"
  sha256 "642da1c89ca4826989581456d22c295e8e8337efaab3b3e16dce40ffedff9d47"
  license "MIT"

  bottle do
    manifest_sha256 "dd2ccb69e50a1f378d7661c440b1988e7984196db25309d4bfd1331e3b437994"
    sha256 cellar: :any, arm64_golden_gate: "9c625574cb4391717d6956a6165cd6dfca9f1095ac4f0617815c8c6f593be77f"
    sha256 cellar: :any, arm64_tahoe:       "d45246ddc100452b8e50d156024e8fd979d77e0393d83e8ee636a26e183dd242"
    sha256 cellar: :any, arm64_sequoia:     "0333c2f872807e69bc3e5644abc239b036e7b63e7d7aa1b361f08614699dbfd5"
    sha256 cellar: :any, arm64_linux:       "db8ed8f0499cd1dc94446502629783e4d83d30c12ddaec1740e6d7c847ccba02"
    sha256 cellar: :any, x86_64_linux:      "75e1b4f95e1d4efb9ef3b636925d86a3e6190ef061f47b484f02332ed00b18aa"
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
    output = shell_output("#{bin}/dicebear create avataaars --output avataaars-0.svg 2>&1")
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
