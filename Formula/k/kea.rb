class Kea < Formula
  desc "DHCP server"
  homepage "https://www.isc.org/kea/"
  # NOTE: the livecheck block is a best guess at excluding development versions.
  #       Check https://www.isc.org/download/#Kea to make sure we're using a stable version.
  url "https://downloads.isc.org/isc/kea/3.2.0/kea-3.2.0.tar.xz"
  sha256 "14bf695d37b65b9b1bf550fea5d0adaf9806c50e5419ef2a176a4b8e9aade3df"
  license "MPL-2.0"
  revision 1
  head "https://gitlab.isc.org/isc-projects/kea.git", branch: "master"

  livecheck do
    url "https://downloads.isc.org/isc/kea/"
    regex(%r{href=["']?v?(\d+\.\d*[02468](?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "759a63203ef99f498d69f5d04042d2e1713c29b3b1bd494996bab76eb4fafd3c"
    sha256 arm64_sequoia: "a66e27fc845bad65651f77cf331fe7c1dc45bee6fba18f3c6ca7da8a6bd78466"
    sha256 arm64_sonoma:  "1e831fa6d2dde7df690e9da68a9e4332909f861ebb5313b58bdf79d2f5499024"
    sha256 sonoma:        "c3f6816a15fedec482f4fce2787de82f4901f0d99bcd172dc9e72b44b85002ed"
    sha256 arm64_linux:   "a0f7281e19533288a569275df5cf8b0f55b7e46e2c5456923f31abe6ea074d37"
    sha256 x86_64_linux:  "1553fe10bd02eb1f6299b45978e21b36daf5ac0f03ae7dbc6b8325ad2d8f8766"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "boost"
  depends_on "log4cplus"
  depends_on "openssl@3"

  def install
    # the build system looks for `sudo` to run some commands, but we don't want to use it
    inreplace "meson.build",
              "SUDO = find_program('sudo', required: false)",
              "SUDO = find_program('', required: false)"

    # Some scripts expect var and etc to be relative paths
    args = %W[
      -Dcpp_std=c++20
      -Dlocalstatedir=#{var.relative_path_from(prefix)}
      -Dsysconfdir=#{etc.relative_path_from(prefix)}
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system sbin/"keactrl", "status"
  end
end
