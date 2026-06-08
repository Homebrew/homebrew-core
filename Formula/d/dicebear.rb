class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.1.0.tgz"
  sha256 "4ae3723cdbe6209de1fb784c95bddcebe89bb5e2d4fd367c1a745cd9e1946d77"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "3fd4d3391ae962ddd772ed8ca3626a6bd0275f03c80686476e9139f7091bd57b"
    sha256               arm64_sequoia: "ce22f6f151ddbdc3048ffe67e0d1097ac87a3cfb16bb08c1b6bf5b1bf7dab1c1"
    sha256               arm64_sonoma:  "7b9ab0a6dd8f692312816738397ce76286bcebaf0121cff7547a6c497a22f65f"
    sha256               sonoma:        "91542536406230ff1bc3b615d688b2c8a678c5bcb4bd3fea4204d126a3701931"
    sha256 cellar: :any, arm64_linux:   "d2d47865bf68d831a27c9cb43a2cd2cda9543ee1c07e2d70a592365a5fc1a75b"
    sha256 cellar: :any, x86_64_linux:  "fff98fdd1a0e7028135d11d1f775d3dcb42d9c7eb76858211da62678df8fdfaa"
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
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilts which still get installed as optional dependencies
    rm_r(libexec.glob("lib/node_modules/dicebear/node_modules/@img/sharp-*"))
  end

  test do
    output = shell_output("#{bin}/dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_path_exists testpath/"avataaars-0.svg"

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/dicebear/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = Formula["vips"].opt_lib/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end
