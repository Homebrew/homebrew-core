class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.14.0.tgz"
  sha256 "c83f48ee76d5cdab7e3bb3d115d7d3751252810e2e127ba3793bcf09a74c9282"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "6c17fbdaa81e2c4a1050f58114928f1093e8b094b6bea909b77dcfe0f9c8e625"
    sha256                               arm64_sequoia: "bca5628cae2d972cf63c64f5bbc4f6db8fef78a5b3e54bd8416ca47007d498dd"
    sha256                               arm64_sonoma:  "4c9cdc149e3e5f96ddf3c7519dabc6989a42e90fc7325365caf482be08375b67"
    sha256                               sonoma:        "85236e2ea600ae1f73d3a4e77cbc18e1eee10f8f167cd241be2b263f3cc09bdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0a6e5d172bad6db89e881453bea9616f65aa0ecc4699163738b87c7458a9ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cc24a348b76e041bbf2204c03e17b89903d79fc2f4b0524a7741f1c90f26127"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.2.0.tgz"
    sha256 "8689bbeb45a3219dfeb5b05a08d000d3b2492e12db02d46c81af0bee5c085fec"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
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
