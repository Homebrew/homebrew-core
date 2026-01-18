class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.3.0.tgz"
  sha256 "b2106cdda1421cec9ab5ad847d72d3ccda4c606b083b6944d6aea56f0168fd3d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d36f2a6c742ae6d9e50816335cde528f5483314bbf7f842c016e1995e6af7765"
    sha256                               arm64_sequoia: "32d0141a00d060a674c4b1b7c9c656fd012b85203fa177c11b5ef58af62fb6ca"
    sha256                               arm64_sonoma:  "2db6560143102be136727e492b9ab2654ce24a7cba9dac5e0904f41090ecde3e"
    sha256                               sonoma:        "20ddab88132fb7aefe8a7b957ce649c107825c1f8f17e3d66acd3ff1f5900b13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a7ab77ae3f17734b50898d296635f535f575cacd9daf1dc07099daf2c34c32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5477809a8b4bef7b6dc7d73b4eb91ec3a5ba0620bd684550216b753c36e189ab"
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
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.5.0.tgz"
    sha256 "d12f07c8162283b6213551855f1da8dac162331374629830b5e640f130f07910"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.0.0.tgz"
    sha256 "bbe606e43a53869933de6129c5158e9b67e43952bc769986bcd877070e85fd1c"
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
