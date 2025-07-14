class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.4.0.tar.gz"
  sha256 "c2ce8302e886b2d3534ec38896a824dc83f43698d085d57bb19a751611d94e86"
  license "GPL-3.0-only"
  revision 2
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "05431b97ae9d2bf393df1d39f1c2d8c97621a279ddb5c3ed2d77d5bc0828fa44"
    sha256 cellar: :any, arm64_sonoma:  "629d8cb5edf13fad83e4a70630e11cd8469ba537a5c27f6aa424d96293018b27"
    sha256 cellar: :any, arm64_ventura: "54d1a923f1982fd68822da1028df83fb0d7c7416897db97f487d4fc4908b1975"
    sha256 cellar: :any, sonoma:        "74d720c90af24ce5e64621d2ca8667fedcd26a93c1a1302b1defdeec0afa01a8"
    sha256 cellar: :any, ventura:       "95af6152a893fb24cbb4e98637e3f3c22c3de42286007ed4c88d20abf72ef74a"
    sha256               arm64_linux:   "d1b978c1b67aea55a70b7abea468c1502869b69dcab423a99a0f839ad9fd45b9"
    sha256               x86_64_linux:  "d1a74d5b71d07ab521b750a889c385849e1fe68fcf2eb00a5fe1e7b4a4526837"
  end

  depends_on "meson" => :build
  depends_on "libarchive"
  depends_on "ninja"
  depends_on "pkgconf"

  uses_from_macos "curl"

  def install
    args = %w[
      -Ddocs=disabled
      -Dlibarchive=enabled
      -Dlibcurl=enabled
      -Dlibpkgconf=enabled
      -Dsamurai=disabled
      -Dtracy=disabled
      --force-fallback-for=tinyjson
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"helloworld.c").write <<~C
      #include <stdio.h>
      int main() {
        puts("hi");
        return 0;
      }
    C
    (testpath/"meson.build").write <<~MESON
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    MESON

    system bin/"muon", "setup", "build"
    assert_path_exists testpath/"build/build.ninja"

    system "ninja", "-C", "build", "--verbose"
    assert_equal "hi", shell_output("build/hello").chomp
  end
end
