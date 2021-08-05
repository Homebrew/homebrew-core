require "language/node"

class Fanyi < Formula
  desc "Mandarin and english translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-5.0.1.tgz"
  sha256 "0f80edeac5e727a299c2a0807f463231143d59b46fd8308ef794390b9d88052c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2456b0530f3fb65613ec1a5911a8f76970a8f7f0f41344df91675ebf1943d755"
    sha256 cellar: :any_skip_relocation, big_sur:       "002883ae0d734a5ea67d80931311a5d8c7b9360a6415ca70f26f41e66dc4d307"
    sha256 cellar: :any_skip_relocation, catalina:      "002883ae0d734a5ea67d80931311a5d8c7b9360a6415ca70f26f41e66dc4d307"
    sha256 cellar: :any_skip_relocation, mojave:        "002883ae0d734a5ea67d80931311a5d8c7b9360a6415ca70f26f41e66dc4d307"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules"/name/"node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    on_macos do
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    assert_match "爱", shell_output("#{bin}/fanyi lov 2>/dev/null")
  end
end
