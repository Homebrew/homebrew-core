class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.5.0.tar.gz"
  sha256 "565c1b6e1e58f7e90d8813fda0e2102df69fb493ddab4cf6a84ce3647466bee5"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ee83480a39f996d669a98cec8b764ae5411b5ffb22ba81c2576a529a90d45f82"
    sha256 cellar: :any, arm64_sequoia: "830db56ee195c9fc5541176c4ff9abaf02e255440879c089f66e91582c720915"
    sha256 cellar: :any, arm64_sonoma:  "34a03c29eafa2fed72cd8f065b6339b562019e3a84a7d1455be2b4748c6cb57d"
    sha256 cellar: :any, arm64_ventura: "fc1623b314de7b4d3e138d0bed0fe271ae2da205eb032bc5da2462bd6927d318"
    sha256 cellar: :any, sonoma:        "7b84b3449e6fab539f2a740c055419775388cf9155711adf63c88f3fe140d0ad"
    sha256 cellar: :any, ventura:       "525804c85af78bda0109ba747ec613d6089312f9bc4d157d2fd1b0dde86c9d71"
    sha256               arm64_linux:   "23221d5b0b3fe07ec7510852ed6cd065326204d26b95bd2ac254d07507cdd07b"
    sha256               x86_64_linux:  "333c9fadf69b0e182ccca75f781c8017e5a5dbc2f0bde8924f6e59b0b1a47ac5"
  end

  depends_on "meson" => :build
  depends_on "scdoc" => :build
  depends_on "libarchive"
  depends_on "ninja"
  depends_on "pkgconf"

  uses_from_macos "curl"

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
