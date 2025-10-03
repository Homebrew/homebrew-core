class Bold < Formula
  desc "Drop-in replacement for Apple system linker ld"
  homepage "https://github.com/kubkon/bold"
  url "https://github.com/kubkon/bold/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7b12aceeabe32249784347f3bb1befde6dcf621668d0352497ee8ef8c381d9ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed79f743395beae0a5c50b97e5915036fc150a64876e09f93a4c23ec22290e11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "166e358558a1248b63764912648a742d9852058095fa8291e6ba5104f1f47145"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "153a08515b6fa639c3245055e773893ee95b9653c87bec5b822734090585afe2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d93e1830b77efb82fa671a2b52a50403292ce2cf991bc9abf2c04a22b57e324"
    sha256 cellar: :any_skip_relocation, sonoma:        "c63ee99bb85ab7dc35e04f09613b7ce775e1933ef264bb10bdf9a5127f2ff7d1"
    sha256 cellar: :any_skip_relocation, ventura:       "c9f50e5f314cfaeb955778838e303f508167ac884b48846ff1c31c786dcd5644"
  end

  depends_on "zig@0.14" => :build
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
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("Hello from Bold");
        return 0;
      }
    C

    system ENV.cc, "-c", "hello.c", "-o", "hello.o"
    arch = Hardware::CPU.arm? ? "arm64" : "x86_64"
    macos_min = MacOS.version.to_s

    system bin/"bold", "hello.o", "-arch", arch, "-macos_version_min", macos_min,
                        "-syslibroot", MacOS.sdk_path, "-lSystem", "-o", "test"

    assert_equal "Hello from Bold", shell_output("./test")
  end
end
