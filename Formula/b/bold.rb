class Bold < Formula
  desc "Drop-in replacement for Apple system linker ld"
  homepage "https://github.com/kubkon/bold"
  url "https://github.com/kubkon/bold/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2496f04e47c9d5e17ef273b26519abf429b5c3e3df6d264f2941735088253ec0"
  license "MIT"

  depends_on "zig" => :build
  depends_on :macos # does not build on linux

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
      -Dstrip=true
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("Hello from Bold\\n");
        return 0;
      }
    EOS

    system ENV.cc, "-c", "hello.c", "-o", "hello.o"
    arch = Hardware::CPU.arm? ? "arm64" : "x86_64"
    macos_min = MacOS.version.to_s

    system bin/"bold", "hello.o", "-arch", arch, "-macos_version_min", macos_min,
                        "-syslibroot", MacOS.sdk_path, "-lSystem", "-o", "test"

    assert_equal "Hello from Bold\n", shell_output("./test")
  end
end
