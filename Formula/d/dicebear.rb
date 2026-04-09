class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.4.2.tgz"
  sha256 "97592b469fe922e6978dd39bcf2c962cd8d45810cea8ca7fc491a60073b58d5e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "746b99ccd13c7e7e271dc8cb4d0fd806abd8ba89315b23b970b184305042bdf6"
    sha256                               arm64_sequoia: "7e479bef26b6f1ada59d1629024f7553989f29de53fa29793a602d2544822aa2"
    sha256                               arm64_sonoma:  "7c15370ad4e3634e7f629773f4d786c58fbae1990dc7222d15025818352016a7"
    sha256                               sonoma:        "cce0d9241ef66695946ac18f8d5a89c14b235ce7b3a11c38072c1e8f96e8731f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6abfe6c30fadcd89090b8d01a1b0ce36015083efe352a3a8567fdcaf99000a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfd673e6b9deea9d83584e853aa314debaa87c95d4e34a485ce655e485e0098b"
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
