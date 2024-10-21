class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.0.2.tgz"
  sha256 "7dfd870bfa5737e032bc7ea73f0c468e06009e1c7f8fd343a8b55fbb9128293e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ae55a61f2d6a0173f41baed8e619bbb707e05aa4893d9bd4de4b786deceb55d0"
    sha256 cellar: :any,                 arm64_sonoma:  "ae55a61f2d6a0173f41baed8e619bbb707e05aa4893d9bd4de4b786deceb55d0"
    sha256 cellar: :any,                 arm64_ventura: "ae55a61f2d6a0173f41baed8e619bbb707e05aa4893d9bd4de4b786deceb55d0"
    sha256 cellar: :any,                 sonoma:        "47487dbe651df2efae7784f75d1bd3415008c822a35316467c9e2d0f58312511"
    sha256 cellar: :any,                 ventura:       "47487dbe651df2efae7784f75d1bd3415008c822a35316467c9e2d0f58312511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36fd34431b0157d9274205f3c1c5c593e96da5d70a5ef497af985274ce0075b9"
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
