class Libansilove < Formula
  desc "Library for converting ANSI, ASCII, and other formats to PNG"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/libansilove/releases/download/1.4.0/libansilove-1.4.0.tar.gz"
  sha256 "f023a9a19549e2dce9fcc4fdba657c4c8df8d385adc65af5c28d32d1df36e71f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "df432ea5d6e8ab5f9ddd76c94e9c9a4f8b711bd886459e0fac0386e95bda8080"
    sha256 cellar: :any,                 arm64_monterey: "1c13c1e9777e8ddd20ef2dd3aed0bfd4932a4626fd5d3062116db5f77fcce405"
    sha256 cellar: :any,                 arm64_big_sur:  "d92dd7d811534e870810e55ceaa6a8b2a900bd3d84fd854fcdea13c09206d77f"
    sha256 cellar: :any,                 ventura:        "b0986c59ea624beed45f768ae2b6046ab6f3cff13d103cdf07056d6048adad5e"
    sha256 cellar: :any,                 monterey:       "526aa3a0ea918f5d709261a1b325dd36233e0e1c59f319e4aa5c0a5a3e68110f"
    sha256 cellar: :any,                 big_sur:        "2ba5bb4351e20a8ebb0fe0cc621d8b81afc6c8c30a715414fae1751fee0a1379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd8aa726a71b68a12d483d65d7d74afa5d10d35be818df0da0d0f8cf00c11324"
  end

  depends_on "cmake" => :build
  depends_on "gd"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ansilove.h>

      int main(int argc, char *argv[])
      {
        struct ansilove_ctx ctx;
        struct ansilove_options options;

        ansilove_init(&ctx, &options);
        ansilove_loadfile(&ctx, "example.c");
        ansilove_ansi(&ctx, &options);
        ansilove_savefile(&ctx, "example.png");
        ansilove_clean(&ctx);
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lansilove", "-o", "test"
    system "./test"
  end
end
