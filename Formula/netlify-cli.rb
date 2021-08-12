require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.2.5.tgz"
  sha256 "bd07011f160698417312faf734bf9e46ca89a6e2ea3dbf62ee8ab20574991f7b"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a419fa46474e5231ec381596ec3ee2d9aada7e919edbc3afcc202be2241caa87"
    sha256 cellar: :any_skip_relocation, big_sur:       "222fb09932a859a8fc464e09759efe1e8f27d866da57b9f759cfb1f328310212"
    sha256 cellar: :any_skip_relocation, catalina:      "222fb09932a859a8fc464e09759efe1e8f27d866da57b9f759cfb1f328310212"
    sha256 cellar: :any_skip_relocation, mojave:        "222fb09932a859a8fc464e09759efe1e8f27d866da57b9f759cfb1f328310212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79c4f9bb89160e067f3f80ffa24d0b8e4eec63a74150a3e4310602a86e718ccd"
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
