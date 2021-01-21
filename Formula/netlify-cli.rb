require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.3.0.tgz"
  sha256 "fe0e0e32a8cf01acbdcd3f4b85e2984bf63b14d78d708e719633e42d8c9bfd27"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f2c22a9a27b8f919fe36e41f636852d159976bf92e8224567ef7cf9401cc6e2f" => :big_sur
    sha256 "ad59cab00565fe3cdd35b06b381b514140209e4e617145cfcf907a3d7f6aded5" => :arm64_big_sur
    sha256 "1f447f7c63c7bb997321bd4aad6be72cdd66a0a719c440d3e73c7df30b7949ec" => :catalina
    sha256 "5f761ef293442d143f994d350fa4570eb696f224a05e94281e1f58c424032460" => :mojave
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
