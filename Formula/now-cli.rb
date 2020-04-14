require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-18.0.0.tgz"
  sha256 "b739879be4417ecfd380e84bc232d95e7f6ed33663fd06828629ed75e6684352"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e0465e8af7455d8609a7d5964dff0a069f1bb93b6360f6d13679ebf52bc18c7" => :catalina
    sha256 "e1fe0405c975b0ff6b6657f03ade395de13316be20f838ef4d84d7fdc1173dc2" => :mojave
    sha256 "438d3d398adb378d0180848d19d8dd285b4c5ac375504313e804fc12eec53dd4" => :high_sierra
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "t.default=getUpdateCommand",
                               "t.default=async()=>'brew upgrade now-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/now", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
