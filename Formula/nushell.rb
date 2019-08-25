class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.2.0.tar.gz"
  sha256 "5bce8cdb33a6580ff15214322bc66945c0b4d93375056865ad30e0415fece3de"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d84b8d315ba2383f90c542689bbfb1def9a24939cda2b5e372961c294b04e0af" => :mojave
    sha256 "751306b30dd9e6c43ca7a1f472d7b6a5b963faf420251addcea8724ca91b4ba6" => :high_sierra
    sha256 "1741fd6332cf1125c1d5eecc9076545041d4ec64ccced6a394fbdf2679bf28b0" => :sierra
  end

  depends_on "openssl"

  # Nu requires features from Rust 1.39 to build, so we can't use Homebrew's
  # Rust; picking a known-good Rust nightly release to use instead.
  resource "rust-nightly" do
    url "https://static.rust-lang.org/dist/2019-08-24/rust-nightly-x86_64-apple-darwin.tar.xz"
    sha256 "104ddea51b758f4962960097e9e0f3cabf2c671ec3148bc745344431bb93605d"
  end

  def install
    resource("rust-nightly").stage do
      system "./install.sh", "--prefix=#{buildpath}/rust-nightly"
      ENV.prepend_path "PATH", "#{buildpath}/rust-nightly/bin"
    end
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "#{Dir.pwd}> 2\n#{Dir.pwd}> CTRL-D\n", pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
  end
end
