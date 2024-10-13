class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.13.3.tgz"
  sha256 "22419fe3354ce4a4e373aaa54160294b8d5cc5ab95ad6b632b07a047c6287378"
  license "MIT"

  bottle do
    rebuild 1
    sha256                               arm64_sequoia:  "f7db10ee18620b1843ff8cd40dab82efe76c49c28f9cb9be0fd4c09c5dd4f010"
    sha256                               arm64_sonoma:   "b8fe2d5de1dd51bad67a53ebe805254ebd9e503a98c9812a16236eeef69c08e0"
    sha256                               arm64_ventura:  "5d245f32ae46a4fa1592417d2cf745c4a7446c3546991ab494e3f27ff6416086"
    sha256                               arm64_monterey: "25049c42733ca1a7df09263eccbcdf1be5545c41d81c33ca5b42979f1e34bc33"
    sha256                               sonoma:         "20a2a322dc10ed9a59548605a0887b4f924c69fbf654bc1dc353b7d911b5d107"
    sha256                               ventura:        "78b5062144fe068949bd4ee0bad05d93969f1b8cee88dc936411bfa95da06b9b"
    sha256                               monterey:       "85597b5631817d7ee9f5d37b36f20666b756909dc0f9057a5c35a8019784a42c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42e95da9728038e6b7a8a8916700f4853f1157703a90c3cc6e99c6a887e1f624"
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
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
