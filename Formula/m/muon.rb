class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.7.1.tar.gz"
  sha256 "967a99ade648a850807d5637c80d55043ded34556e9dcbfec8736d6de52f96c5"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "608de2f0b59f4f90f53bcb672f80fc5ef667c765fccd5fbd3b5757560c7270fe"
    sha256 cellar: :any, arm64_tahoe:       "6a06d19a10745b5542c47fa256e1a4e2aad1ac463f26c934cd725a88e33ac100"
    sha256 cellar: :any, arm64_sequoia:     "59f7bd9f474e181add4df42cb1f1aea5f47034a3efc9d2430945e8e01b07b525"
    sha256 cellar: :any, arm64_linux:       "c65de661c70bcece4a36074d5d4813e19e015f5d5e18faf983c444b554695f50"
    sha256 cellar: :any, x86_64_linux:      "19192c0d609d75bb852b84a33dca8e555f1a65200463595eacbcdd9d78daa49f"
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
