class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https://chewing.im/"
  url "https://codeberg.org/chewing/libchewing/releases/download/v0.13.1/libchewing-0.13.1.tar.zst"
  sha256 "c897a5d0aadfdeb07784e1411ceac0efef2c97bea8143fb3b1dcde8274e14fc0"
  license "LGPL-2.1-only"
  head "https://codeberg.org/chewing/libchewing.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d40f3a8796693535bdc3c78bd9087487d98876bf0ee1dd6f39fff90f274b9777"
    sha256 cellar: :any, arm64_tahoe:       "523a12b90702988206afde2b19eed70b23e704c21d090139167e0d0949d3273a"
    sha256 cellar: :any, arm64_sequoia:     "14007c3e17daecc4a41911311d6b74ca1502e11230187c2cedaae37845f2c07c"
    sha256 cellar: :any, arm64_linux:       "28f17d077f16e1b420b8b266c6b8295ada1f5fc45339c7e09f7acad6fa7085a2"
    sha256 cellar: :any, x86_64_linux:      "2a58739f398d09b15f2435cd803b3bc7e07e0ed61f58b22e819a25cafbb3b0a7"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build
  depends_on "texinfo" => :build

  uses_from_macos "sqlite"

  deny_network_access!

  def fetch
    odie "Remove `cargo generate-lockfile`!" if build.stable? && version > "0.13.1"
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <stdlib.h>
      #include <chewing/chewing.h>
      int main()
      {
          ChewingContext *ctx = chewing_new();
          chewing_handle_Default(ctx, 'x');
          chewing_handle_Default(ctx, 'm');
          chewing_handle_Default(ctx, '4');
          chewing_handle_Default(ctx, 't');
          chewing_handle_Default(ctx, '8');
          chewing_handle_Default(ctx, '6');
          chewing_handle_Enter(ctx);
          char *buf = chewing_commit_String(ctx);
          free(buf);
          chewing_delete(ctx);
          return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-L#{lib}", "-lchewing", "-o", "test"
    system "./test"
  end
end
