class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "5df7386911bc15fd1ca783132528748d219768ae4fc5f8e0b61184f041648092"
  license "BSD-2-Clause-Patent"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "962e5b553f735b609bc632da6da1dfa0774b4e84aeef8dce638b748a9aff2966"
    sha256 cellar: :any, arm64_tahoe:       "703f56cd94ba6bb86ee1463bec792d8ad6f9841f67152fa6e93040b966bbf82f"
    sha256 cellar: :any, arm64_sequoia:     "d3cf35724639ceb6d9d92ee25a7fa4953f7ff952dc4be90aa83eb006910248b4"
    sha256 cellar: :any, arm64_linux:       "759d38fe01e34a9c0eef7c001a8431ddd87d139f7bdf4a9e34706c714214d8ea"
    sha256 cellar: :any, x86_64_linux:      "f7c74f138725548feae2bc8478202bf23d6cf063da33f03e09f28043270b423b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  uses_from_macos "vim" => :build # needed for xxd

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "meson", "setup", "build", "libvmaf", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "model"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libvmaf/libvmaf.h>
      int main() {
        return 0;
      }
    C

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/libvmaf",
      "-L#{lib}",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
