class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "83a70a15bc2da41f081a44ebc58ee48e2e1d524a6d3fdb4a24064afa08d5ad4d"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "493490c6c5249bfc7b07cd5bf2f8564a61b71586034c48bf6476525696a31315"
    sha256 cellar: :any, arm64_tahoe:       "d75ec69bc88cef73779767051f99213c77faac034091f59236072ee91ab4489f"
    sha256 cellar: :any, arm64_sequoia:     "131c156f5a88c943d7a010a6401ee4c648029b8f0c63f1b3dabe52c98693e997"
    sha256 cellar: :any, arm64_sonoma:      "d8ea828bdbcc8a3126f3f1f27158f4fe0df81909017037f7f3ac8efa21de8ed0"
    sha256 cellar: :any, arm64_linux:       "6b0046f71e6f249bb43b24c21abdb39cdc44f180eaa41dacad94e258d5767a2e"
    sha256 cellar: :any, x86_64_linux:      "51fcda7bcdd74e373a73a666cd6a7ed54a0fe25aacc503bc94938533a4d1b5dd"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"try.c").write <<~C
      #include <cgif.h>
      int main() {
        CGIF_Config config = {0};
        CGIF *cgif;

        cgif = cgif_newgif(&config);

        return 0;
      }
    C
    system ENV.cc, "try.c", "-L#{lib}", "-lcgif", "-o", "try"
    system "./try"
  end
end
