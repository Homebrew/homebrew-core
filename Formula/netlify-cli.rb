require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-5.4.0.tgz"
  sha256 "a4c1a48d6552bf4b83f98cd0afadd5a42e5042b8e7e576f06d3face99b9f8f51"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1f377c9cfd048b74da46941201de0407d33ec4edc178ecd7f49b795a0b4e6726"
    sha256 cellar: :any_skip_relocation, big_sur:       "f5ff0a91c7527fc54e7a49e4aff3b6242348dfb22872d5d5e63d4bf61a878c1b"
    sha256 cellar: :any_skip_relocation, catalina:      "f5ff0a91c7527fc54e7a49e4aff3b6242348dfb22872d5d5e63d4bf61a878c1b"
    sha256 cellar: :any_skip_relocation, mojave:        "f5ff0a91c7527fc54e7a49e4aff3b6242348dfb22872d5d5e63d4bf61a878c1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "395d74bf0deb64dad3e2bcca1cd452474b6451fe603cca0ea8be30807ecd1675"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules/#{name}/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    on_macos do
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
