class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.5.1.tgz"
  sha256 "137d9a6d5b447ba4d0c3d71f2ce01b8b4a077cd1cad1202bf7845da72882635a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0d0c05f4ea3a84e1a1ad7320d837b7079efc6a725252aecb58e8406ef4d576b7"
    sha256                               arm64_sequoia: "f6013398b495a61fe7efce9da3bcd2db96e157b63448ec682c68d355f581e509"
    sha256                               arm64_sonoma:  "f6bb3b7262e974d1642e6bf45321507399d9b1b487573c014693b82df496f434"
    sha256                               arm64_ventura: "8a8da504010c765191a6b3d10d224c807836dbdebbc16da00bb057e8b01fc603"
    sha256                               sonoma:        "4dac2afe374ac7363a20638f2e2f07b51df0141979e741feecb73c9f78ac77e1"
    sha256                               ventura:       "3ba1052e47f90c0f85edf4762b3b5ed7fb2a6419e94b7be3bb3fec453679c121"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c7e2c5fa01127328385f302e8935498c35e76afdc4a28ddbe2af7691205b5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae0a2b2ac285b8b286c7210bbfe073064b459be83752e5fa92dd7b2e9702d978"
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
