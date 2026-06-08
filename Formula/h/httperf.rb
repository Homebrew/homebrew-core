class Httperf < Formula
  desc "Tool for measuring webserver performance"
  homepage "https://github.com/httperf/httperf"
  license "GPL-2.0-or-later"
  revision 3

  stable do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/httperf/httperf-0.9.0.tar.gz"
    sha256 "e1a0bf56bcb746c04674c47b6cfa531fad24e45e9c6de02aea0d1c5f85a2bf1c"

    # Upstream patch for OpenSSL 1.1 compatibility
    # https://github.com/httperf/httperf/pull/48
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/httperf/openssl-1.1.diff"
      sha256 "69d5003f60f5e46d25813775bbf861366fb751da4e0e4d2fe7530d7bb3f3660a"
    end
  end

  # Until the upstream GitHub repository creates a new release (something after
  # 0.9.0), we're unable to create a check that can identify new versions.
  livecheck do
    skip "No version information available to check"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7058120f2bc830d162abe7e7f1732bd35a69a9b1467e9ba159457f91aba5eba5"
    sha256 cellar: :any,                 arm64_sequoia: "efe2209f501fece87251e41daa112b47530b39045e957fb0e8e443e883ba465b"
    sha256 cellar: :any,                 arm64_sonoma:  "128020ec8910a993fd4253aaaf848fdc7bed1234ef0a7a3639585c20f94cd9f9"
    sha256 cellar: :any,                 sonoma:        "da89b4e50527278fc0af4c2aaa3290003f977c22672b7e673e2b03dcb256964a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ecbd4326f2fd13255046d1e1b6abbb57a6d8f63422bb117c71793208990f8cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abd5a6cf1f8ca58e2d76742f0a9907c0110b7ebf90bc72c59a528b8eaf49b931"
  end

  head do
    url "https://github.com/httperf/httperf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@4"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    # idleconn.c:164:28: error: passing argument 2 of ‘connect’ from incompatible pointer type
    ENV.append_to_cflags "-Wno-error=incompatible-pointer-types"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"httperf", "--version"
  end
end
