class Lutok < Formula
  desc "Lightweight C++ API for Lua"
  homepage "https://github.com/freebsd/lutok"
  url "https://github.com/freebsd/lutok/releases/download/lutok-0.6.3/lutok-0.6.3.tar.gz"
  sha256 "5f33fdf8be36c2d95b866947ff49aa4a90ffd6f10a6172d9ed9243f6a6b42f18"
  license "BSD-3-Clause"
  head "https://github.com/freebsd/lutok.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "af1205184b8736260d544a0dda5103b6cf7a01b98c2ee06ad227b6e7cd8bb249"
    sha256 cellar: :any, arm64_tahoe:       "06a6f522db223ff41e67fb28cea46f0e24d8f09a457b5d8caa69944e08ecb0a8"
    sha256 cellar: :any, arm64_sequoia:     "477f60409c479d51f20b6467b202b97919db6e55809957f06ec541b7af7ac541"
    sha256 cellar: :any, arm64_sonoma:      "12d966b62f0fafcce6a8fe964a756e10db17b607ca556890f9f982d6daff2eb5"
    sha256 cellar: :any, arm64_linux:       "cdc4e113066fac43195aee24f430ecac72ca79074f14c6bc2c60def0b8b9188e"
    sha256 cellar: :any, x86_64_linux:      "cc327216db439ec4987c36ddd4a72a6353d65e64ff89400fb86328a0bdbde126"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "lua"

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
