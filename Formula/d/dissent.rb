class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "7c5e10a6111cd8912c052337c56cb04cbb92b237453d560c85409f1c8f8cc01b"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "447bf4a3f5a064df2f4e5c0c0c3131fe6212c0978e06741809b18853921810c3"
    sha256 cellar: :any,                 arm64_ventura:  "d18368812743ff9e7cc21b561aa137c0698a96bd76e4aaadc6bbd4bc1178ceb4"
    sha256 cellar: :any,                 arm64_monterey: "3813049fcbfa8b14054700fa1608882118c7083264dacd3d7673e7e67fc0cfde"
    sha256 cellar: :any,                 sonoma:         "68fb1c64b89c9b145a2d322ca70566f777cce85603f4e2c10732afb556dfb059"
    sha256 cellar: :any,                 ventura:        "39513cbc5a7e853884c1857d1d0b6575717c19c7e3c2b89cd2447858c7bf3038"
    sha256 cellar: :any,                 monterey:       "f721d3e16f6cd9aca035a6fc01a99bb461a19dbe1a0f3b7b1bb6f2b9a8c0fd38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72bbb0fc22aebe42eacdd3ffd8e9a3737fc7268073514e064614e79f90e652b4"
  end

  depends_on "go" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "libcanberra"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # dissent is a GUI application
    system bin/"dissent", "--help"
  end
end
