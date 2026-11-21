class Faad2 < Formula
  desc "ISO AAC audio decoder compatibility shim"
  homepage "https://freewareadvancedaudio.github.io"
  url "https://github.com/FreewareAdvancedAudio/faad2/archive/refs/tags/2.12.0.tar.gz"
  sha256 "69e4f048c6aec5a099b2b8ca318dcb1c224d1056be0b320e8f7d11706016b1ec"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "15d889dc25b77a061642b62d94aafae9989197babc254580666e400ce25fb485"
    sha256 cellar: :any, arm64_tahoe:       "a1c6012d8a4d604d30f684d72ccf39c5c0aab2c724a4868f2cc143f52fed0dfc"
    sha256 cellar: :any, arm64_sequoia:     "b9875c841217859d9c92d675b4cf719d53145cbafee9bac95273713822f55281"
    sha256 cellar: :any, arm64_linux:       "ddf1e8094dd399ed3bd3e5c779005185b9d02fd43a27f574f156f60d8d243d69"
    sha256 cellar: :any, x86_64_linux:      "74bee1119ba9061e934ac3b2d3963993658f6ea775676545ca0997022ed7ee24"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "faac"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DFAAC_USE_BUNDLED_SOURCE=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      The `faad` command-line tool is now provided by the `faac` formula.
      Its options changed: `-f` takes `wav` or `raw`, `-b` takes `16`, `24`,
      `32` or `32f`, and `-d` defaults to mono.
    EOS
  end

  test do
    assert_path_exists lib/shared_library("libfaad_drm", 2)

    (testpath/"test.c").write <<~C
      #include <neaacdec.h>

      int main(void)
      {
        NeAACDecHandle h = NeAACDecOpen();
        if (!h) return 1;
        NeAACDecClose(h);
        return 0;
      }
    C
    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs faad2").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags, "-Wl,-rpath,#{lib}"
    system "./test"
  end
end
