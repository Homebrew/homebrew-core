class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://github.com/NeoRaider/fastd"
  url "https://github.com/NeoRaider/fastd.git",
      tag:      "v22",
      revision: "0f47d83eac2047d33efdab6eeaa9f81f17e3ebd1"
  license "BSD-2-Clause"
  head "https://github.com/NeoRaider/fastd.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a8f1263ce16085e5b01e6ffca44731ab1600332666bac3eafed55dc83e22bc4f"
    sha256 cellar: :any, big_sur:       "a05e3210aecdfddd308b8ea828bbd32bd7d016deb7cca77dfaf07f4d981506c4"
    sha256 cellar: :any, catalina:      "33e3a81748094389e5d7bd4cc894a75a01f40891f1a4693c4ea3e16014e912cb"
    sha256 cellar: :any, mojave:        "eb48fd5b2eab89e016223dbbfdf5faaf6a4e0194f0a3e5711218c4f3d83727f5"
    sha256 cellar: :any, high_sierra:   "5064081410018559132b1f2a970f897130474fa3f9919bd51c5e17253a67ed76"
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

  # remove in next release
  patch do
    url "https://github.com/NeoRaider/fastd/commit/89abc48e60e182f8d57e924df16acf33c6670a9b.patch?full_index=1"
    sha256 "7bcac7dc288961a34830ef0552e1f9985f1b818aa37978b281f542a26fb059b9"
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
