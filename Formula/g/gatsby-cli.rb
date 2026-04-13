class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.com/docs/reference/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.16.0.tgz"
  sha256 "312014d94558e08b829c5aadf736ecc6a221d137c3e1bcaa3812bbe23eea5bab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ec0da04fcc872c2f86669578e894eecaaa36f6d06dbf842fdae0459ac09ef77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ec0da04fcc872c2f86669578e894eecaaa36f6d06dbf842fdae0459ac09ef77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ec0da04fcc872c2f86669578e894eecaaa36f6d06dbf842fdae0459ac09ef77"
    sha256 cellar: :any_skip_relocation, sonoma:        "4282280166a175ed9b5df0c29549a697307c85e294a7a33f5cb4b74dd613c33e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6422a57c8317368134d02e4388b39783f9f3ceed917bae008d756d2610e06dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f732a727f1571ef419773bcf65bbe98240f865746a749cf7740a6e791b10792"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/#{name}/node_modules"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.linux?
      %w[@lmdb/lmdb @msgpackr-extract/msgpackr-extract].each do |mod|
        node_modules.glob("#{mod}-linux-#{arch}/*.musl.node")
                    .map(&:unlink)
                    .empty? && raise("Unable to find #{mod} musl library to delete.")
      end
    end

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
    # Workaround for https://github.com/nodejs/node-addon-api/issues/1007
    ENV.append "CXXFLAGS", "-std=c++17" if OS.linux?

    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_path_exists testpath/"hello-world/package.json", "package.json was not cloned"
  end
end
