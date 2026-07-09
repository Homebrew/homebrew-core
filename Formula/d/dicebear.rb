class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://www.dicebear.com"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.3.0.tgz"
  sha256 "f5429e21cf6580e2f8624cd20aae776f4c263f5e743f5f75b5f99006c6567837"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "2674c4965f61e4a97a51c556239433b8ee96a7996ce0ae0df9d572c00872f75b"
    sha256               arm64_sequoia: "816f1e45cecb8cf09b1f66976cbbe991b1b07ee43e608f7583d36fbfb0793b40"
    sha256               arm64_sonoma:  "c21822aa6268db9925be60d0cc19a3266975e981f0a4b152c8ce979751fb73f4"
    sha256               sonoma:        "26c82f8475e7fbe4a32b595bf94b0112d30cbada4776664886cff6f9500e15ea"
    sha256 cellar: :any, arm64_linux:   "c3a63e0374669fd207c71f8707bfce3c342d73483203dc0d9bb584bddbc9a9e2"
    sha256 cellar: :any, x86_64_linux:  "f1fa8dec1ea89119107243ee47c940cd55eae6c49c5d892b304a5618d348da15"
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
    libvips = formula_opt_lib("vips")/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end
