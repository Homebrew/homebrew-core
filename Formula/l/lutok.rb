class Lutok < Formula
  desc "Lightweight C++ API for Lua"
  homepage "https://github.com/freebsd/lutok"
  url "https://github.com/freebsd/lutok/releases/download/lutok-0.7.0/lutok-0.7.0.tar.gz"
  sha256 "a4cd62a30490ead9ac7502bb49bde2ed7b7dcbe7f7d2ec76a4f5f0be4133939f"
  license "BSD-3-Clause"
  compatibility_version 2
  head "https://github.com/freebsd/lutok.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "38471e985fda4e169d3342470c939cd8a010f99aae791abcf79f0a0718b939b8"
    sha256 cellar: :any, arm64_golden_gate: "5f4e15c33b6ecad87007c0f4b5bd66866d4a99ad2f0c2c18aa62a20cfa98a1f9"
    sha256 cellar: :any, arm64_tahoe:       "bcf39cd2c05e74018f490c6a2546ac9c509532dc616e79651eff39bf113a458d"
    sha256 cellar: :any, arm64_sequoia:     "75eb9ca416a0f00dac63766a3f0962afe375b505b449bbade2914a6a79a15f7c"
    sha256 cellar: :any, arm64_linux:       "ce8e7c3c328eb02859e0aead0a619519573f8d0907d8337d5a406ff3b0dc7810"
    sha256 cellar: :any, x86_64_linux:      "80264c88437d168095dd6cac18e281a263dcc45c0d66b96dc04257578fea0030"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "lua"

  deny_network_access!

  def install
    system "glibtoolize", "--force", "--install"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <lutok/state.hpp>
      #include <iostream>
      int main() {
          lutok::state lua;
          lua.open_base();
          lua.load_string("print('Hello from Lua')");
          lua.pcall(0, 0, 0);
          return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs lutok").chomp.split
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test", *flags
    system "./test"
  end
end
