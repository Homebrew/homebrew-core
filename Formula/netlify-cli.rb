require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.3.0.tgz"
  sha256 "eea7c825f818cbaf715f9327b5135a58df6b23844ed5c92647688cff74c31ff7"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6a1e651e6f17b876fd45953cc4552b2213960b30c79f231ec8a98a41312192d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "ddfa968db51757fbf609f0205fcc51dfba0dc1930630e5d73c39aff7510424e6"
    sha256 cellar: :any_skip_relocation, catalina:      "ddfa968db51757fbf609f0205fcc51dfba0dc1930630e5d73c39aff7510424e6"
    sha256 cellar: :any_skip_relocation, mojave:        "ddfa968db51757fbf609f0205fcc51dfba0dc1930630e5d73c39aff7510424e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "410eecc68a1696c8e408140faab3b1bac235066a7d90e413a1f93c581b314ee7"
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
