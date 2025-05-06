class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-21.0.0.tgz"
  sha256 "d6eca8ad5da0fcc142378b12197e0062e21039cd867bdc60be9468c82d29dce1"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "1e1b4b5f7ce9afb865758fac85d91a351b23324f5458aa1a6b5c0811af1cb576"
    sha256                               arm64_sonoma:  "e9120f4bbe830328ae2fd6ae820c32b4dc6ca30f01f18e71f7f7ebb2274f3cbd"
    sha256                               arm64_ventura: "eb9aacff69b8131aa3fb308272d4cb0a56a369e6d88b825156b65d80d44ddbe9"
    sha256                               sonoma:        "c4f46a42c0be4b2467e86daf1dd55126ef668883e0d8465f4be659c68fcf4f6b"
    sha256                               ventura:       "48bbb9f5255d44b3b68cea22bf2dcd736813c8161f07ca0783ceec1d5ddb31b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec73b653535921e281581362304d3f5af4c9a0a057d75cd1d1b383878104fbf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "385b37cbb3787fe52e38b1729aad0ecbb4cef682ce08f115ecd025a1b6812f63"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
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
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
