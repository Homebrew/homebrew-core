class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.13.4.tgz"
  sha256 "dd22575ed9b99d11f724c5afb07104a120e477c92a267fc03700560fef8738ac"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "25591bbe2b6da6549c4fd6231f312aed40a0b5e39f9cf438d73f9c572ed70104"
    sha256                               arm64_sequoia: "c5ff4ceb3b1b34f301de94f5ae9d2cfc9e227c0e3e1f4677e47969b738093a88"
    sha256                               arm64_sonoma:  "72c0ca2d3d363a9f6596d2b7877379e073a9f129ce5324075ae892ffa2dadf9f"
    sha256                               sonoma:        "0b8998827450b994b325707e7eaa23c9ad4c183bfaf1b16e43effd7284ba7073"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24e90dcffc52166d00be40be53b7eacc83579c993ffccab7e961ad1e5a6d5086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1110159a9decfade42739a48486f2923216139b404f399dc66220cabab95c2b6"
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
