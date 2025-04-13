class Bold < Formula
  desc "Drop-in replacement for Apple system linker ld"
  homepage "https://github.com/kubkon/bold"
  url "https://github.com/kubkon/bold/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2496f04e47c9d5e17ef273b26519abf429b5c3e3df6d264f2941735088253ec0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1deba05b1a4ab3d20a443e7b5a11f63b6cfc44f2996c41dce352fbdc48e78db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75029020d0fa32ee7573f9c730b9bbb09a6c98fb310dee951b284df022dfd3b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e4087ae6dc9a698588838f127ed739eaa55d899b143efd5079b40a613db6d1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2539d42202287085cf3e89c7e06fce587166465fbb8df8ba4fa23cf8bde298d1"
    sha256 cellar: :any_skip_relocation, ventura:       "84a0a90973ee9a14a971d3c700f64bd164167518bcb978830080d5361c13ba5c"
  end

  depends_on "zig" => :build
  depends_on :macos # does not build on linux

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = ["-Dstrip=true"]

    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args
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
