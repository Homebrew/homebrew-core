class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://github.com/NeoRaider/fastd"
  url "https://github.com/NeoRaider/fastd.git",
      tag:      "v21",
      revision: "2ce6095b2795052e34110599c484205468fb9fa6"
  license "BSD-2-Clause"
  head "https://github.com/NeoRaider/fastd.git"

  bottle do
    cellar :any
    sha256 "a05e3210aecdfddd308b8ea828bbd32bd7d016deb7cca77dfaf07f4d981506c4" => :big_sur
    sha256 "a8f1263ce16085e5b01e6ffca44731ab1600332666bac3eafed55dc83e22bc4f" => :arm64_big_sur
    sha256 "33e3a81748094389e5d7bd4cc894a75a01f40891f1a4693c4ea3e16014e912cb" => :catalina
    sha256 "eb48fd5b2eab89e016223dbbfdf5faaf6a4e0194f0a3e5711218c4f3d83727f5" => :mojave
    sha256 "5064081410018559132b1f2a970f897130474fa3f9919bd51c5e17253a67ed76" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsodium"
  depends_on "libuecc"
  depends_on "openssl@1.1"

  patch do
    url "https://github.com/NeoRaider/fastd/commit/0d4045fb85d85903ebb9afe03a08d9b089300062.patch?full_index=1"
    sha256 "bb0d62e40575408497c6a285e6443c8386b4b85427463dd29df7736f3fe4ae9f"
  end

  def install
    mkdir "build" do
      system "meson", "-DENABLE_LTO=ON", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/fastd", "--generate-key"
  end
end
