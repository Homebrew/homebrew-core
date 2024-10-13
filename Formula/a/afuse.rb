class Afuse < Formula
  desc "Automounting file system implemented in userspace with FUSE"
  homepage "https://github.com/pcarrier/afuse/"
  url "https://github.com/pcarrier/afuse/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "87284e3f7973f5a61eea4a37880512c01f0b8bf1d37a8988447efbe806ec3414"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2d36270c3d62319e03cf6f11756308f5a1f1daef36cebb7ef19376a795002014"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "FUSE library version", pipe_output("#{bin}/afuse --version 2>&1")
  end
end
