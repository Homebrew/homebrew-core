class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.8.1.tgz"
  sha256 "5147c078b2193729efe5f0c220051032b070860ec48c0ccc639eace67450b9ac"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9d365bbd52bd30e5bd315bff2016a67d61b5cd150d7371dec9e559c0347714e7"
    sha256                               arm64_sequoia: "cad437bcf1ce810d7d7a32ba13a6808af6e25bc41d616a4a3da78d266d0ae5fd"
    sha256                               arm64_sonoma:  "68a81427c97cc14f6c65175d832d2ae92edad5fa22497518e151e15403094326"
    sha256                               sonoma:        "0c019e847e35776245cfe7ba1c1cb46b5fecf0855d7d8e261f0963ec8e7b6f38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b81242260e026fd09edc3c3d5959ee4dfc3c2ec1eaab784c3ba70f7828997d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8f431db38304f639d6e875b5c4382d198c8409277b3f7c7c332f1cbbd633769"
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
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")
  end
end
