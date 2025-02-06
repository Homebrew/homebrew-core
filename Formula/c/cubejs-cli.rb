class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.0.tgz"
  sha256 "39c4241d621269f93621bc3ece014997a5caa6569b254f19c6f1b2ca41d50f30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7afa8891c4762214a3ee2e4f50606b599e1d503ad00c7f448496cfbe2a8031ab"
    sha256 cellar: :any,                 arm64_sonoma:  "7afa8891c4762214a3ee2e4f50606b599e1d503ad00c7f448496cfbe2a8031ab"
    sha256 cellar: :any,                 arm64_ventura: "7afa8891c4762214a3ee2e4f50606b599e1d503ad00c7f448496cfbe2a8031ab"
    sha256 cellar: :any,                 sonoma:        "c0e30059d925e1c9cbb06d0ccad5ca6cbcfc088f078cd985c85c70ea071da57c"
    sha256 cellar: :any,                 ventura:       "c0e30059d925e1c9cbb06d0ccad5ca6cbcfc088f078cd985c85c70ea071da57c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbeb7aa6edf57ada630d336004b83cce0040ff57fd81c3293ba766be999fd444"
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
