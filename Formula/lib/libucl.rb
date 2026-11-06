class Libucl < Formula
  desc "Universal configuration library parser"
  homepage "https://github.com/vstakhov/libucl"
  url "https://github.com/vstakhov/libucl/archive/refs/tags/0.10.0.tar.gz"
  sha256 "3e27a97d48561aa262f93715ad5b483dceca02b033662b9a5a29c36f48b518e7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2c987363c2aa4194644eeaee384db8e018c6b550ecade0ee5c6236be4523640c"
    sha256 cellar: :any, arm64_tahoe:       "3967d61a155c8377a6f9f8b38fc42d49df09eaa4ac1b24d418948d68d25d22c9"
    sha256 cellar: :any, arm64_sequoia:     "d574d99deec33e5548162abd805e89a83310aa6e076724db43e9f1fcbea73767"
    sha256 cellar: :any, arm64_linux:       "1dc23ca8e9340e7fd1df6e5e22b8dc98defe702fe4c5e65165a7d541b38792fe"
    sha256 cellar: :any, x86_64_linux:      "538d5ff610d8ff0671f7a304a20d9f4f157afcc2e901d2fb487db32d7d59e872"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  deny_network_access!

  def install
    system "./autogen.sh"

    args = %w[
      --disable-silent-rules
      --enable-utils
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ucl++.h>
      #include <string>
      #include <cassert>

      int main(int argc, char **argv) {
        const std::string cfg = "foo = bar; section { flag = true; }";
        std::string err;
        auto obj = ucl::Ucl::parse(cfg, err);
        assert(obj);
        assert(obj[std::string("foo")].string_value() == "bar");
        assert(obj[std::string("section")][std::string("flag")].bool_value());
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lucl", "-o", "test"
    system "./test"
  end
end
