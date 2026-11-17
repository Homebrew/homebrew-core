class Portless < Formula
  desc "Replace port numbers with stable, named local URLs for humans and agents"
  homepage "https://portless.sh"
  url "https://registry.npmjs.org/portless/-/portless-0.18.0.tgz"
  sha256 "6aff621696d4f0a3bc2c607c6d8cadf7383767ca34afd627557144e7062c4759"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47576f9fa28c92990e333cb8d017d6c7b5d05bf60edd9ab9668078aa0766649d"
  end

  depends_on "node"

  deny_network_access!

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["PORTLESS_STATE_DIR"] = (testpath/".portless").to_s
    ENV["PORTLESS_PORT"] = "1355"
    ENV["PORTLESS_HTTPS"] = "0"

    assert_match "myapp.localhost -> 127.0.0.1:4795", shell_output("#{bin}/portless alias myapp 4795")
    assert_equal "http://myapp.localhost:1355", shell_output("#{bin}/portless get myapp").chomp
  end
end
