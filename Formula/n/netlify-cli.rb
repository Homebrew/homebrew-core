class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.13.3.tgz"
  sha256 "bf4d6fa389ebd6d916d88345cb55eae70a241edc90cad3182f3951e63339900c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3cbdc54caf20eb20812cd5ba61f41bb609e0e94798e792d0744d42f02921cab4"
    sha256                               arm64_sequoia: "ded2f366e3341c47e44933a5d1d3a46a4e0b13ad0316648d3b3fe5261da79e17"
    sha256                               arm64_sonoma:  "e35060a48d76e5eb54b9a4976a05134a4cbaf75a6303f6628e4303f6c8664e3b"
    sha256                               sonoma:        "dd633bb4a3660bd897e52dd1cf63cbd388f2e93ef0f219df5dc2923c93ef2bb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd875549c82dd28ce33fbcf2e9181cc3c1a9bb444938c696895ccd2767d6ade7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee494dceeccc729e14aa9a2f466f9d9681f2a27194c70d0709eaad57ef3ef156"
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
