class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.4.0.tar.gz"
  sha256 "c2ce8302e886b2d3534ec38896a824dc83f43698d085d57bb19a751611d94e86"
  license "GPL-3.0-only"
  revision 1
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "c6f0a6432a429272a8dfe0fc8c463ff95cbed4059fcc49c0b2d83e0437e72ba3"
    sha256 cellar: :any, arm64_sonoma:  "edb4791c7f8790b96b4361e3a4886ad654b977a90f52fb9632b5e4af622e1e34"
    sha256 cellar: :any, arm64_ventura: "328b33b0c04a614dbc4b5ec87b842530dc75b92ab729d4e0bd79b4922ea4e04f"
    sha256 cellar: :any, sonoma:        "9f5a94990f9ba7dad39a19b227ab8a43c1e1957a82cd49eff60a33d9015b3d0d"
    sha256 cellar: :any, ventura:       "1093a8dc08368070464f5c182b80df1196b6e4a04f70978072ae9f66f5297c99"
    sha256               arm64_linux:   "59e9b0a588a9beb8c1f5f5b953c368f0a5073e5a61884af80325b9b22a566f05"
    sha256               x86_64_linux:  "e9f55dec1f94791d47db778e7ae1288523f02ec2b3bf676976e678e8915d4aa1"
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
