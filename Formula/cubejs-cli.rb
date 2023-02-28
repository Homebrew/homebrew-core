require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.67.tgz"
  sha256 "edd1bf111a3d3b7f07f5e72a5f2feac9cb2c5b5e59ba85d2548782432a24d555"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec8e5d72f0bc0e3cf563a30790a315be78b36c8e6b76208849b351c3add60bd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec8e5d72f0bc0e3cf563a30790a315be78b36c8e6b76208849b351c3add60bd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec8e5d72f0bc0e3cf563a30790a315be78b36c8e6b76208849b351c3add60bd4"
    sha256 cellar: :any_skip_relocation, ventura:        "945b8a4649cde8479c0d653559d40f4688906b6cf0551cfabfa4eb7d3c209ee4"
    sha256 cellar: :any_skip_relocation, monterey:       "945b8a4649cde8479c0d653559d40f4688906b6cf0551cfabfa4eb7d3c209ee4"
    sha256 cellar: :any_skip_relocation, big_sur:        "945b8a4649cde8479c0d653559d40f4688906b6cf0551cfabfa4eb7d3c209ee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec8e5d72f0bc0e3cf563a30790a315be78b36c8e6b76208849b351c3add60bd4"
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
