class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.15.1.tgz"
  sha256 "cf778b29e9f0fac995f25661a910334f854bff940d4c3035c6efe8c18d9a2e09"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ed6030aacdde089b330c737302a060dd55fe786037d70372947637056317e101"
    sha256                               arm64_sequoia: "933b8cefaced1a2ed24e020a30962c01c89b20ab70885d954e49410e411e2090"
    sha256                               arm64_sonoma:  "6ed0077a6d49bf520fe67a262fa56cdd1676bc29fc2741df7e7c556b24603f23"
    sha256                               sonoma:        "85ee2ed68bf899d561e30d767baa41ec3f2c37f65c56ed527c362ac113e4dafc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9e2ee238c809aa75063760bad1f65ff94a812abeabbbad631d147a73e8e2bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f79357fb854a6615a48872121a63ff37f64c6120e1f8fdb303327bb465983e"
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
