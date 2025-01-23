class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-18.0.2.tgz"
  sha256 "0e0e4a96394c2cc7ee79e47d2be1258c62be7ecde2bb5cfc4d2ac4ea01a75eb4"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "4ee1fbe534b3cf27619f2eb2f0dfe211cd7600b7a8df2d1c6f767fecf992d48d"
    sha256                               arm64_sonoma:  "11e9261639675e9715b7d4c285489d0e0dc52541fdac9c92e34c49aa7927689a"
    sha256                               arm64_ventura: "18a3c59ffffa7254e769837ed0cfbb239c63d4c31f5523f1bad802b53f5fa20c"
    sha256                               sonoma:        "db694cd8313f6369e6373321869687e6c2e15d273495e4fe84601b90b3430364"
    sha256                               ventura:       "b174a6cfcce7cd08726a8dd129fcc1d032acc239c75355a85ac1d17ff6b73af1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c5ee9d4f4579775a645b773410180b6aabb0d1419e8b942e4c89248a68971c9"
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
