class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.2.4.tgz"
  sha256 "ab8e430f1b4fb999372cf78b274e04ca999fff16891f19ece63f63ab7f7aa373"
  license "MIT"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "1b976223644c8e073419d9faab43f37ea04cf575b2ffc6273335c9b3bdbdb05c"
    sha256                               arm64_sequoia: "8b3bbe8b750c33981cd3682062ac7842bea26e9d996dc61ed42478b454421b34"
    sha256                               arm64_sonoma:  "c7a5f82835088e08c93ee24cc708c74d0757a487ab611725442a485d990b5e14"
    sha256                               sonoma:        "cdffe3248922f05d9a5374bcd987bfc6216cf2d4ff5c73e3040f14040f99e464"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22a9186779dfb53b76481329c4d8888185ebb087d5c1af3b4094272a05bb24dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "303a1d6e868ebe7d9b6d46eef48cbc17b5dd9d5d58338a804a8c659535536aa9"
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
    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
