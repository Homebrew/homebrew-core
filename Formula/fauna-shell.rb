require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.5.0.tgz"
  sha256 "b365080e638d85104a9ae533c6271c2dae692a5d6cc09f7fdb15d5c8870a96aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "c74cf761b3354938d35f713128e78afb610d93fba0fde9206dde9a4d0d06f861" => :mojave
    sha256 "941fd32dc26568e076a23a0596ae4a8baee48344977164220261b093f7e9003a" => :high_sierra
    sha256 "c057a90e347ce2e728c037993f671e77e06ebe79a6273bd059c050cf57514b74" => :sierra
    sha256 "84f9a21962a5fb407ee12d19e930820781ac2d00825d54917f17a675e0a130d5" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    pipe_output("#{bin}/fauna add-endpoint https://endpoint1:8443", "secret\nendpoint1\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_equal "endpoint1 *\n", output
  end
end
