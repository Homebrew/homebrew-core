class Portless < Formula
  desc "Replace port numbers with stable, named local URLs for humans and agents"
  homepage "https://portless.sh"
  url "https://registry.npmjs.org/portless/-/portless-0.18.1.tgz"
  sha256 "f362d68270a847e8193be946c26c44eff0f2649e33c2cfe60af135f711e04ca9"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "7f32179e8709742de2c1e7dfcb4c29aa23cde77dd5f7e80e2b626093a6e2f0d1"
    sha256 cellar: :any_skip_relocation, all: "3d89cf7474a5bd791dc0247b3aa437160fa6de934af547a3d41bd66a560c4c6f"
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
