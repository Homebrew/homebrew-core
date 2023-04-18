class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/refs/tags/0.4.18.tar.gz"
  sha256 "0b4a9218d88f6cf9fa25996a3f38329a11f688a9d026141d9d0e966d8fa63837"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "6246d732f961d77005bd78e3e26dcb17ca6e30db717ff15153e318567e2d50d2"
    sha256 arm64_monterey: "443454cdeda3546c1d04c36f51d1c71312806abd99ac968dfa22ee6dd3ac6119"
    sha256 arm64_big_sur:  "00438a3c641cdb2326ad06e45f446ec78bd247740415d5f969cd14875c6f6902"
    sha256 ventura:        "1dfa2bf3dec13e70f0a4af42f131cddea3016de6e0a3c12bcf9e595f2e13c911"
    sha256 monterey:       "b1de5bf78ffc1fc870d383cd713c438e181d037506d11c95c9dafffe302e05e1"
    sha256 big_sur:        "b22d402e7747a6a4f725c0cef38256d29292544b6117be5f761627182be3b585"
    sha256 x86_64_linux:   "9e610ba5049b018c45b4c2a8eeae8f01391227dc30189d54ecd476496d6fdbba"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11"

  on_linux do
    depends_on "dbus"
    depends_on "glib"
  end

  # patch for `Unknown CMake command "px_check_modules"`
  # remove in next release
  patch do
    url "https://github.com/libproxy/libproxy/commit/8fec01ed4b95afc71bf7710bf5b736a5de03b343.patch?full_index=1"
    sha256 "af7f90c68f3807fefb3d8502a5180f9d71b749f21c956fc5be8a1c049ce88d05"
  end

  def install
    ENV.cxx11

    args = %W[
      -DPYTHON3_SITEPKG_DIR=#{prefix/Language::Python.site_packages("python3.11")}
      -DWITH_PERL=OFF
      -DWITH_PYTHON2=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "direct://", pipe_output("#{bin}/proxy 127.0.0.1").chomp
  end
end
