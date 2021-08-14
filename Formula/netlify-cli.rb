require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.3.5.tgz"
  sha256 "1ac5c273d62293050cc059a38c461cd6a34f3aaf6a7305a070f9b251814e0bc9"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7cc9624ba0db9ddb8b0db4885aabb8404ef7b010c3dde19cfb5ed18bd7a9f1ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd5b23d50d1b480f8262701cb4d3868bc50fc5fcd1b887259aab31667faf0535"
    sha256 cellar: :any_skip_relocation, catalina:      "fd5b23d50d1b480f8262701cb4d3868bc50fc5fcd1b887259aab31667faf0535"
    sha256 cellar: :any_skip_relocation, mojave:        "fd5b23d50d1b480f8262701cb4d3868bc50fc5fcd1b887259aab31667faf0535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13cc2c90c73993109681eb0304d060fb06582a8aecb6fdbc57b97fe3e3c0cd5a"
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
