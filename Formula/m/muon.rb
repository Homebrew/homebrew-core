class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.6.0.tar.gz"
  sha256 "5300e58c4b4d43e3026856004c79d746075aaa9d9e66d76ba9f32ce249495b81"
  license "GPL-3.0-only"
  revision 1
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c3af796c6628f025bc700fad4962e84957562cd7b80fd0f385c7232004d6a4d7"
    sha256 cellar: :any, arm64_sequoia: "abc53dd90783afe1513fac848bb470928694aa9182338c4c77c851e9ed6c79af"
    sha256 cellar: :any, arm64_sonoma:  "c33b3bf841fd604e4183a3f1e74e562d7b77cb6f529f4605e001533047a2ece7"
    sha256 cellar: :any, sonoma:        "bb847167aacfd86ba683abe2f1c57b79d8bd74a3d1d49bf3032cb5f671512663"
    sha256               arm64_linux:   "ec095f7ec3fdda1b0a7ea78f001b20df5f53151b57767d1f7c4e21c439434d3a"
    sha256               x86_64_linux:  "359ecc0df71b16ac47053badeb972fdec52142ac0ebf9697f7b582a585c57e87"
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
