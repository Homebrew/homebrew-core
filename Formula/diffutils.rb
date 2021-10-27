class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/s/diffutils/"
  url "https://ftp.gnu.org/gnu/diffutils/diffutils-3.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/diffutils/diffutils-3.8.tar.xz"
  sha256 "a6bdd7d1b31266d11c4f4de6c1b748d4607ab0231af5188fc2533d0ae2438fec"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4261be9ec928e4e841efd205eef060dc8a536b033c7d4377eae6e51f099b9eb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "239aaf4a4b3e63ade873472f3442e6a910130f1f999b494ee02fa6acffa11c0b"
    sha256 cellar: :any_skip_relocation, monterey:       "64ddb0cccbc7163969ac093ca0251053991af34393188d3457695a358a0f3034"
    sha256 cellar: :any_skip_relocation, big_sur:        "43ed975b1f8cd9c8aedc16848691972950c2c95405395bc646650fbf8e3d60c5"
    sha256 cellar: :any_skip_relocation, catalina:       "c0a2132f021243dc25d19e6638eea2a423e09957d2c6c11582fc134301fffefd"
    sha256 cellar: :any_skip_relocation, mojave:         "20cf9f34754b7c6c84ff790fe2240e072705a074a2af81f1ca25796801de2780"
    sha256                               x86_64_linux:   "54486cec2842e69ad311ec74cdba142385784d00d3f8cb79fd745864a19c2d7f"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"diff", "a", "b"
  end
end
