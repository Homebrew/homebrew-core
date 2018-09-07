require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.8.0.tgz"
  sha256 "b5a545c05362f360dfebdf7c75c309f7e231d9cb90bbd9167f3a44daa59d3373"

  bottle do
    cellar :any_skip_relocation
    sha256 "f859d1f423b9224099bb48b2254d53e049ef733e11c09e33fdea57a6e75b243a" => :high_sierra
    sha256 "a071222007d77fa0f154a02510b3728b2b39d82b3791f48318b8491400093c46" => :sierra
    sha256 "dd5b056d7a18577ece3807c3c9461d5dbfe2a1e21003d2f30c3a59421d375729" => :el_capitan
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
