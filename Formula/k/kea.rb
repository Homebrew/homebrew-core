class Kea < Formula
  desc "DHCP server"
  homepage "https://www.isc.org/kea/"
  # NOTE: the livecheck block is a best guess at excluding development versions.
  #       Check https://www.isc.org/download/#Kea to make sure we're using a stable version.
  url "https://downloads.isc.org/isc/kea/3.2.1/kea-3.2.1.tar.xz"
  sha256 "3478220be62b3aa361a2c7f97d5d2989b934f7864e82d4bd17056e1e208b9735"
  license "MPL-2.0"
  head "https://gitlab.isc.org/isc-projects/kea.git", branch: "master"

  livecheck do
    url "https://downloads.isc.org/isc/kea/"
    regex(%r{href=["']?v?(\d+\.\d*[02468](?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 arm64_golden_gate: "be5dc2ab36b9d8ca6c63f6c9a6b5ad5db89c20afe8362639037dd19f53a3d2c3"
    sha256 arm64_tahoe:       "c280bb0c0e457809def0fa213da09a7b66c26c71999af180cecd4016959e50a6"
    sha256 arm64_sequoia:     "09165f679b1b8953d170fd380d13f01aa9639222d6c5922d848baa961e2576ce"
    sha256 arm64_linux:       "480b658ab8687d4ee1db93ceb9b91321de9b7b8f415835c11c8640e34269cb3b"
    sha256 x86_64_linux:      "2689b6ef31a99a7ff28f2665f905cac253593c079cb6816b2b49b601588d1d17"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => :build
  depends_on "boost" => :no_linkage
  depends_on "log4cplus"
  depends_on "openssl@4"

  deny_network_access!

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
