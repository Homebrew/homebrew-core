class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.7.0.tar.gz"
  sha256 "e7095741dc11338f5ed8e0aa02e993fc34df4295dad4296127bbb212bcf56e07"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b75e9e9651745f3f0d77ae7c3470fb2942f3ea5b6c0fef1508eb871bccc1bd94"
    sha256 cellar: :any, arm64_tahoe:       "866dcb5260e54fc2781a325c9710a3829454eb2aaf25549bf24af6643b241ace"
    sha256 cellar: :any, arm64_sequoia:     "0b0bea767ed852dd5b5f8d8e57cf5d1a669ade43aaed53a09224209a9787a09c"
    sha256 cellar: :any, arm64_linux:       "9dff2a1e250bfd230b7e47f85a0c8ccd64c5652ccf18fcd0625e1a60a9b55fd9"
    sha256 cellar: :any, x86_64_linux:      "34325a3d2399fa798f73627834c834c86e7e710f42d6427274afbb7805637183"
  end

  depends_on "meson" => :build
  depends_on "scdoc" => :build
  depends_on "libarchive"
  depends_on "ninja"
  depends_on "pkgconf"

  uses_from_macos "curl"

  deny_network_access!

  def install
    args = %w[
      -Dman-pages=enabled
      -Dmeson-docs=disabled
      -Dmeson-tests=disabled
      -Dlibarchive=enabled
      -Dlibcurl=enabled
      -Dlibpkgconf=enabled
      -Dsamurai=disabled
      -Dtracy=disabled
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
