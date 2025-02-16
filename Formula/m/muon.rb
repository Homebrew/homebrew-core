class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.4.0.tar.gz"
  sha256 "c2ce8302e886b2d3534ec38896a824dc83f43698d085d57bb19a751611d94e86"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "b2b8c6d772f66d4c71e3724687de62b2f714375ea0bcc75f4e3a1d11eb8bbccb"
    sha256 cellar: :any, arm64_sonoma:  "1d1d98fa14817ffcd261bd64fd32eac654246264fdba18539f4b73d99c532cdb"
    sha256 cellar: :any, arm64_ventura: "c271f60c94867a291d56da52874dd7c8541922bbc8d34739cf97854a36f6d725"
    sha256 cellar: :any, sonoma:        "790f382df5f4d1d906e575e56a51074936a3a983383895346f3f5bfac782f4d4"
    sha256 cellar: :any, ventura:       "cdbb9dcb25b3a7f3609737f28677a443aaca43507440f6230f856d566422442d"
    sha256               x86_64_linux:  "e57306fc3cb90ee4c9b65558c2fb867d45dbd1a13a060cdbce93167cc17b2def"
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
