require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.3.5.tgz"
  sha256 "1ac5c273d62293050cc059a38c461cd6a34f3aaf6a7305a070f9b251814e0bc9"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d944f2da6878e48341f2e52a98ac4d7569934d8e00113473eaabb878cc14b3a"
    sha256 cellar: :any_skip_relocation, big_sur:       "aacc0f440ad646ef47d4ee2a554cd6a42e004cf2013324ea69cbd64b2c6e5875"
    sha256 cellar: :any_skip_relocation, catalina:      "aacc0f440ad646ef47d4ee2a554cd6a42e004cf2013324ea69cbd64b2c6e5875"
    sha256 cellar: :any_skip_relocation, mojave:        "aacc0f440ad646ef47d4ee2a554cd6a42e004cf2013324ea69cbd64b2c6e5875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c1218ca403537a64ab40e0ad3439b617f7d126bd428b247028819eb07e6899c"
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
