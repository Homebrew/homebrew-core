require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.9.tgz"
  sha256 "80a270f195eed74e3e4f2604ccb1a157e2002fb738d73e04e92f80f25e51f7e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dce063b941be660313164dc4398acf01864bc59073f283faa06cd5766d88ab5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dce063b941be660313164dc4398acf01864bc59073f283faa06cd5766d88ab5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dce063b941be660313164dc4398acf01864bc59073f283faa06cd5766d88ab5"
    sha256 cellar: :any_skip_relocation, ventura:        "44ba5c9712cf3c2ee97c92b751a4ab72d04e8a6e2e510a81885a895a7f2cd985"
    sha256 cellar: :any_skip_relocation, monterey:       "44ba5c9712cf3c2ee97c92b751a4ab72d04e8a6e2e510a81885a895a7f2cd985"
    sha256 cellar: :any_skip_relocation, big_sur:        "44ba5c9712cf3c2ee97c92b751a4ab72d04e8a6e2e510a81885a895a7f2cd985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dce063b941be660313164dc4398acf01864bc59073f283faa06cd5766d88ab5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
