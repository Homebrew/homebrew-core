require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.0.tgz"
  sha256 "8670fb5f9a0f701d3c5c4492ffd6ada0658e41ed856c15857cde33e14742c515"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "25b5b2fe05321697f512356589d157361542b66c14f7f130aa3000a02352fa5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d6af4e057f6b3273be692617acffe12ea51004972bfe4b46e590644f7c695566"
    sha256 cellar: :any_skip_relocation, catalina: "7dbdf6096ff5da6c2486d4032a6dae56a8d261f12fb5635d071dbfe061802f8b"
    sha256 cellar: :any_skip_relocation, mojave: "d38b069917c5c778d870280920a3c676310f910f6ca0cea26ac251edbf5e7fc6"
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
