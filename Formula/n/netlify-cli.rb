class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-21.5.0.tgz"
  sha256 "79d55a6b8633f0dc9da32ada9a0d48db6582b7805fa5a38d002fac3e05300033"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "5c67212c679b47a3109000a7b41ed61159a0485cf6dc17486da0fe3b04028c3e"
    sha256                               arm64_sonoma:  "fe429a3e6987091919538cc9e0c25ec02e6b0417c8f7b43a716c64d60415c590"
    sha256                               arm64_ventura: "b4c64ef718c0d14f0a206fb1eae5cba865e2c17a696720da2279f434ab9d7e73"
    sha256                               sonoma:        "2a35c8e11a26ba131aacca6d7a8187583eb243966442da1eab30c97f753d083e"
    sha256                               ventura:       "83158bdbf7108b127663ce59c304036ef3c05725ea7a033401c8e7bfde66f182"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "821df14ff5bd05483502f04b19e911c61eb1c950eeef98cd9db3dbef8009e0e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c0cd3806d9795a24e620a4609fea84cfbdc9719694f18062a1c064cb112722f"
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
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")
  end
end
