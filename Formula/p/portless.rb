class Portless < Formula
  desc "Replace port numbers with stable, named local URLs for humans and agents"
  homepage "https://portless.sh"
  url "https://registry.npmjs.org/portless/-/portless-0.18.1.tgz"
  sha256 "f362d68270a847e8193be946c26c44eff0f2649e33c2cfe60af135f711e04ca9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86c288661bccbb6d262a72e52e68970f247b89cbab16d8d6da105e5334e44d0a"
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
