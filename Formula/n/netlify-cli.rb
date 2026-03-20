class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-24.3.0.tgz"
  sha256 "6de973daed8960bc735d5512c40c7727c4b4e1d25ef0eeb05be75928cabd37d3"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "975047cf180a25f571dbd8cc2aa278be47eaf34d39502b185d048131cffc17c7"
    sha256                               arm64_sequoia: "33fc562335eafd2651fd0a2c168b41d04c07c01558cdc4ffa77a35e1abd40439"
    sha256                               arm64_sonoma:  "7bffb11343009f04d9c473237cf7a8b22da465eae570d3c3abcf3da2bf21f2e7"
    sha256                               sonoma:        "679b9172652c4c36d5ddad527a76ca66a66cf6363cb5458fbc0aacb171e5e35c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6016cb87d37f21397b42d9d1464f9c832d546ca1e10eb64537ac7e667292d478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "472fdac6155b7bd853d8748bd6303926ceb0d21b48ad9d379cfa047bbac35820"
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

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
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
