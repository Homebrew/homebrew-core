class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://www.dicebear.com"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.6.1.tgz"
  sha256 "65606df941583bf78575117cd2ab54e4ea99bf148e66ae8c389cca4c38d0c326"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "801ad8cc78fa9a57c029fbd4929a9106a2ddd514b3f279f3b1f7c8df7f2627a1"
    sha256               arm64_sequoia: "4fac93ef48db1c61ce3d42df234ec728582838beee9295b4e1b9c8f693d7d661"
    sha256               arm64_sonoma:  "5ac4f78bc32dc5cc1bedfbbff5af5505b10426df46b8fd45f59de3ced6a9a320"
    sha256               sonoma:        "6e7a12a1288835da3996188ddd574434835a0eb931a17af39f641cd86dae40f0"
    sha256 cellar: :any, arm64_linux:   "8bd977c441a1ecf712d2e3fd4675b4e5339ee60ff3fc61265641b8ab2ef6ffc7"
    sha256 cellar: :any, x86_64_linux:  "45cbd9cd8fe0486dccbf3449775e2546f5acd9fe3abb562975f4388ecaafe9cf"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"
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
