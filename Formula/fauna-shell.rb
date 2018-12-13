require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.9.0.tgz"
  sha256 "36b2191b9ac7a265ba23b388437a939e8416d80e8d500d8aa66c2ff65d35318b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d60fe8ae48742c2198a1a08ba2c5e6b14a41fb454ee58272eca112008d0aa4c1" => :mojave
    sha256 "7f6d73360719340389bde034af0b6149b6b030f8b0535d6ff6f76b1ece76929f" => :high_sierra
    sha256 "2405d973f33f06335b0721bb9aa7b038bffa054737c4dc54269ee41eb0e2b63d" => :sierra
    sha256 "b50feb636a87bb55fa54635a185039c44a53eb8585bda362e4c1343610488b09" => :el_capitan
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
