class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.9.1.tgz"
  sha256 "d28903678ce2886a9dc2b5b51411eb59008fcd99c9b0a27fc8a045f7f3a81a29"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ca94b603867829d9aadba53577e7ff805b5de18734cde857d597b82e7e627dc4"
    sha256                               arm64_sequoia: "6de98bf9c092dd12119eacfa925f7c7ea7e16930bc0ebb48d78a5a712c33c929"
    sha256                               arm64_sonoma:  "213e6eafee148492582788959dc682ddd169b9b7d0599f6143f78d0162fde7d1"
    sha256                               sonoma:        "be26a319a2a25bbef309aeb55f2b552af8d78671c6c31a1995bc0006c26cf50c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18ab340a2ae229ffb4e3354abfba48b51efdd8b04b7590b4f01516f7e641831b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18026cbd1c68a0e167b4f2009f0da12ae3de89715de6f124f34b406dcdb5236d"
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
