require "language/node"

class NodeSassAT4 < Formula
  desc "Node.js bindings to libsass"
  homepage "https://github.com/sass/node-sass"
  url "https://registry.npmjs.org/node-sass/-/node-sass-4.14.1.tgz"
  sha256 "7e372a40c5fc2b5bcbccdc712190dc80df7deebd029ce15395fee3694f2e1ea0"
  license "MIT"

  keg_only :versioned_formula

  depends_on "node@14"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    node = Formula["node@14"].opt_bin/"node"

    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    output = shell_output("#{node} #{bin}/node-sass --output-style=compressed test.scss").strip
    assert_equal "div img{border:0px}", output
  end
end
