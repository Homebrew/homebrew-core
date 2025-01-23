class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.3.1.tar.gz"
  sha256 "14b175b29c4390a69c1d9b5758b4689f0456c749822476af67511f007be2e503"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "5e336a491680267b43243f20cdbcfe57fd1332409035bb03659c58918986a77d"
    sha256 cellar: :any, arm64_sonoma:  "c2768a449afbd15b502243c3119b6208da3c49b40c1aebaffdf8ef618f9df703"
    sha256 cellar: :any, arm64_ventura: "ed8593dca5cdbb2a62925ec881dcd89aaf7693663638b63db132e58ddcd13ae0"
    sha256 cellar: :any, sonoma:        "4fa0ea6e0be923f3ec8f87831cd82de214fbf2f418860a5b2566fa97a77c9553"
    sha256 cellar: :any, ventura:       "ca0c576169d567306e7c01d366714484af0035cab22150dcf09eb1d2837cce2f"
    sha256               x86_64_linux:  "000291c5f9b9c0cd5e91f02d9dc6cf9fc3ff0216198587ed814c298241e4be76"
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
    assert_predicate testpath/"build/build.ninja", :exist?

    system "ninja", "-C", "build", "--verbose"
    assert_equal "hi", shell_output("build/hello").chomp
  end
end
