require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.2.0.tgz"
  sha256 "e5ccee88e164363f37eef0bdf20e3c17375bf70f47e54c27ef3b0d499261f0b2"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "45ae70ae4d0c93bb3f63ff46259fe66dc30126861964224e524b715a8421a9a7"
    sha256 cellar: :any_skip_relocation, big_sur:       "8f4ffcb4ba67a36a76147788b87053e0ab2456ebdb534be372997db971326c06"
    sha256 cellar: :any_skip_relocation, catalina:      "8f4ffcb4ba67a36a76147788b87053e0ab2456ebdb534be372997db971326c06"
    sha256 cellar: :any_skip_relocation, mojave:        "8f4ffcb4ba67a36a76147788b87053e0ab2456ebdb534be372997db971326c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b957b400f7c026925129603415316c7dcbc1a47c62625beb54dff5a05738552f"
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
