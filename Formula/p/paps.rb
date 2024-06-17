class Paps < Formula
  desc "Pango to PostScript converter"
  homepage "https://github.com/dov/paps"
  url "https://github.com/dov/paps/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8fd8db04e6f8c5c164806d2c1b5fea6096daf583f83f06d1e4813ea61edc291f"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "78ee471e29dc3f714aadff0385280973225a6c1ae5116684a1a8edec97be517d"
    sha256 cellar: :any, arm64_ventura:  "c3879ff04dc0f1f00c27b53cf77ee50381c0385509a5cfaa790229b6aaf4411c"
    sha256 cellar: :any, arm64_monterey: "1c9dec96fe4e4a5de3265ba1e861bfd2b4fc1fe75a48f035472a1c5354f257c4"
    sha256 cellar: :any, arm64_big_sur:  "fb997c783473d62aa8d86159c90397f89017e93e0c7f9f855926f6ec6936e096"
    sha256 cellar: :any, sonoma:         "371a5486683174985fbc2f6ae16221979edecf5fd9d56c8fbed22dd4f683b827"
    sha256 cellar: :any, ventura:        "403b5bfafbda176686cffdf04975f7afa0863df2a41df04215f9e72c8ccd51ef"
    sha256 cellar: :any, monterey:       "06b336d256bd4147beed5266c02aeb34233dc2fbd0aba4f2d666819e8da856f9"
    sha256 cellar: :any, big_sur:        "d7a38d585b97d3a04b947f13b79129d756f14c8bf44185c29aa780d182f32842"
    sha256               x86_64_linux:   "1aaa98e10292d47452e9bd79f0664b026d6fc49779bcd9c86fb0ca510b927cec"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "pango"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples"
  end

  test do
    system bin/"paps", pkgshare/"examples/small-hello.utf8", "--encoding=UTF-8", "-o", "paps.ps"
    assert_predicate testpath/"paps.ps", :exist?
    assert_match "%!PS-Adobe-3.0", (testpath/"paps.ps").read
  end
end
