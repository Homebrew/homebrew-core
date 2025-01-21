class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.15.tgz"
  sha256 "0b45d5083fd18b094388ca86b35b3b04165ffc502bad6c4cdf375c1673cf3a63"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1aeea8575348aae1b3099e603bf2418546ae1cfdcd6045642a2034db5dcd7537"
    sha256 cellar: :any,                 arm64_sonoma:  "1aeea8575348aae1b3099e603bf2418546ae1cfdcd6045642a2034db5dcd7537"
    sha256 cellar: :any,                 arm64_ventura: "1aeea8575348aae1b3099e603bf2418546ae1cfdcd6045642a2034db5dcd7537"
    sha256 cellar: :any,                 sonoma:        "f466c9f3e80e10aa0fa7c6f5c5531ddb4d730f0b672bcc4d210c73402bd0de41"
    sha256 cellar: :any,                 ventura:       "f466c9f3e80e10aa0fa7c6f5c5531ddb4d730f0b672bcc4d210c73402bd0de41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acce345c88a386915652f646af90266f25a4feee25c12aff008eb161b61906ae"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
