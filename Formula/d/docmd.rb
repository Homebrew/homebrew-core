class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.6.2.tgz"
  sha256 "d5f0ea6db5f4985174a8879ca9091a9091aedca98b1227edc63cc607611eda03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dfed2f9bbd94977c1f941b21b4ecb758c23251f5cd2d3e0f9882c29e1bb3b2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc1919cd4ce1cf99fa3675dd69f75462bd33c724707bdda2bebfaa79d8aa3db0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc1919cd4ce1cf99fa3675dd69f75462bd33c724707bdda2bebfaa79d8aa3db0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a83c1d3ad2208c43bfb54426dc959752593d42647bc7dcc3997d61aba8b1045"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ad545403ed4363cb10344da4122e63b917777b710667253f1cdecc79e2f9d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ad545403ed4363cb10344da4122e63b917777b710667253f1cdecc79e2f9d97"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@docmd/core/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@docmd/core/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.js"
    assert_match 'title: "Welcome"', (testpath/"docs/index.md").read
  end
end
