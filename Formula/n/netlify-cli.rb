class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.12.2.tgz"
  sha256 "1a8d73f083b8812856ba46aeeec0cfd9d0028a1155a23b0c3720f54e2a16ea6d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4314298c92b70edcc47cb2163ac70f130ecf3bcda0ef6d15696e91009ebd89ea"
    sha256                               arm64_sequoia: "f2118e95d95220f89d07f6308c36619416bb6ae418d06668c0e9dd8bb9120b5b"
    sha256                               arm64_sonoma:  "10adb737aa31b9dc2c74124fd8354082c630dc681d08700238f2a327bf4d5365"
    sha256                               sonoma:        "6ad2c4cb00a7fc927ff8879fc365e15bf41b533380af29f4400fcd3c0dfe3ad6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4172fe0e69ec7d981d3057b6db2a614385189dec522977ed42354c03ac9d1d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581a0123df1dab22ad7160d0425a5519472bafe6e77bb44a94e05f4a7d1af633"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gmp"
    depends_on "xsel"
  end

  # Resource needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.1.0.tgz"
    sha256 "492bca8e813411386e61e488f95b375262aa8f262e6e8b20d162e26bdf025f16"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible and unneeded pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"
    rm_r(node_modules.glob("@img/sharp-*"))
    rm_r(node_modules.glob("@parcel/watcher-{darwin,linux}*"))

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/netlify-cli/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = Formula["vips"].opt_lib/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end
