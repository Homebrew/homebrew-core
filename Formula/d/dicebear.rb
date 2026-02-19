class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.3.1.tgz"
  sha256 "7a40cf4d738a6af316c99c3da362c3cb5a78533a4ad1149e3c743a4fcc6cd7f0"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2d5ee46cf65d1eb6ef46da43fa6e1238c2eace5aefd170d90ac0128bdc61ab3b"
    sha256                               arm64_sequoia: "c31306aec607575a24b5556321a908bc582112e9c70657989a9f885a6b2adff3"
    sha256                               arm64_sonoma:  "d9950382ea3c4285094b20e258f702348e2ef9fabddf4994cfd0bcefacbbb6b4"
    sha256                               sonoma:        "8a30f942c5c108fcde545de589925a80ea4dd63d62b324202384c946e1c30b31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "283028b6c943843197d6a502e929ffa3e9a82f815978de6ff95feccb876104e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0920a24a23355b16c54b7af5ad07df0e4c567243c64cb44e53fec48ade5fc7e8"
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
