class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-22.2.2.tgz"
  sha256 "28be7723acbf67296266d5c6756a40896507c729bf462470a80af9a15c61bd96"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "65c964a30b232065576c7229d488c4c0c9a85e2481828c8131a8c8a67096fd20"
    sha256                               arm64_sonoma:  "c19c04872f54562f9d160f2ad4782fa7a9be86b6eb622576a3323845f092ed02"
    sha256                               arm64_ventura: "840d7a85062a76320c80e8c8ed6e9acb00525f12d2984ff6a4f0105d72b9b441"
    sha256                               sonoma:        "460862e0d8d10608c74593774ee5ffa260cdbea8aaf1c0a76db368df219153d3"
    sha256                               ventura:       "d4ce1f9498a64937b180dd8f3dab8938aeeeb1eec1aeb0570dcbd1546a8b1668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d633b033b0f229ff605bfd41342f5459af3c46f716b1ea71c798556cd715b6d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a15eebd3abfbf376f57e651861b9b4a8924026405b8b39c3f3ba285afa25a77"
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
