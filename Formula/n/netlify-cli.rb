class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.13.5.tgz"
  sha256 "da31cd866b029488caa00ee653b22b0a06cafc002a8f3844094004ff9fb7362f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1276a04e9c5040da4b88dab78fd1abc933ac94a23aebbdac1a281250a11d1da2"
    sha256                               arm64_sequoia: "b041709aa4601867c555bde31a5dfc45de9a174c5ed3cb6b402cc2baa4f5abbc"
    sha256                               arm64_sonoma:  "9c0ad36a2144674338c8ae2e398e971cdd1274e8b5eba3ed482e9d38cd88a6be"
    sha256                               sonoma:        "a99e8135e2e0795e26b17cb10e755fa2b6150d6cf596674545601dda555c6bc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e2b7af2296f8e1d7569390529079ddbf7f45df553af60504c5fc90ae0b6fdb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34a0b01bd600434529d426c050467dd1007c07e12dd258497a3095912d484f21"
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
