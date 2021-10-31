class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.21.1/libpsl-0.21.1.tar.gz"
  sha256 "ac6ce1e1fbd4d0254c4ddb9d37f1fa99dec83619c1253328155206b896210d4c"
  license "MIT"
  revision 4

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "71a2a391b3f6d0e78d96c91bf594e552f85b0ec0b3e6fa670277a5e35dd0bf54"
    sha256 cellar: :any,                 arm64_big_sur:  "8313e729e4b764ace521bcae3e703a0cc3f90eb8facc680702c92a4d5fe5ab3a"
    sha256 cellar: :any,                 monterey:       "32573b319cfad0812e881347b48c015fa822a87ff8bb23f1ae5c46448150043c"
    sha256 cellar: :any,                 big_sur:        "6529b32db8b5f83c74d16f60faf10a569774d6499edee836d3198f2a8c365ec2"
    sha256 cellar: :any,                 catalina:       "911026d2b262765bfcb83502d7e541006d903c8210907635232ecfdf457f1241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "551f9a28be34f8edadb438e4a60b662644e5e6c702baf88f959e693cb8444a58"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "icu4c"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Druntime=libicu", "-Dbuiltin=libicu", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libpsl.h>
      #include <assert.h>

      int main(void)
      {
          const char *domain = ".eu";
          const char *cookie_domain = ".eu";
          const psl_ctx_t *psl = psl_builtin();

          assert(psl_is_public_suffix(psl, domain));

          psl_free(psl);

          return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lpsl"
    system "./test"
  end
end
