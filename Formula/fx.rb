require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-16.0.0.tgz"
  sha256 "a33b2b9253ed8326b176f279082b0893f5c4f352d522f6f1a26e77d3d5968565"

  bottle do
    cellar :any_skip_relocation
    sha256 "395f54f7c035e3916d06f1d9dbe27440ed2db1d32566d2795036cde9b6ce26c9" => :catalina
    sha256 "fd98c71ecebfb448fdf5569f02e7840e521855877ab82e0318aea8c8211292bb" => :mojave
    sha256 "e3fd516fcf23eb067ef443b9d82994bc809036bd4c5494ceec0c4ab64a3f9326" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "bar", shell_output("echo '{\"foo\": \"bar\"}' #{bin}/fx .foo")
  end
end
