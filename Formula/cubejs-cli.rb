require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.25.32.tgz"
  sha256 "60d716977e299e7bf66f082ff8edd804b2c20f3c34b0949dc483f2489804a7a5"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "24f01db5bbff2d101cc63e198c9d55df86dad6a8452dff141ba09632789ad2df" => :big_sur
    sha256 "9cdafac858ba213f0bc98fd0e7dd1530d389c834951403da98282bf0549ee01d" => :arm64_big_sur
    sha256 "e5bc316688ad88c301a4bfcb15b623a37a4e5d9c7631816635e436b182eabe0f" => :catalina
    sha256 "0382eed9b6a43ce1b6090528b6b4a9e35481def7ac5492becf858e3174240ca0" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
