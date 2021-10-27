class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.17.tar.gz"
  sha256 "88c624711412665515e2800a7e564aabb5b3ee781b9820eca9168035b0de60a9"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/libproxy/libproxy.git"

  bottle do
    sha256 arm64_monterey: "ea29465d14b64ce0efdd879f98ecfad0731ba1bafff27aae5e257d78f4ddc84f"
    sha256 arm64_big_sur:  "535133b549c369ced715e3e017d0ddeec32376a4b29469d2b18cef030b50fbe0"
    sha256 monterey:       "22ef963f09431f28e2a50eb716cbff03a5369992640302fe4da3219674fbaab2"
    sha256 big_sur:        "b2d8852168ed2484cadb96d11dc3e69126822dcd544ec7e5c66d0694287ad451"
    sha256 catalina:       "c4811050c47e7178cb3ae6a5e675925d0448a39883a4a76b9d0f2d63e6ea1d53"
    sha256 mojave:         "9e6c0ba9fb2215eb447b9613bdc62c18fc95fb0f3e681c44c794671189a20b56"
    sha256 x86_64_linux:   "68c92b8f108d46bd729293dcf26294c030c71dcef6f9ab29c3d280017bf8e149"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10"

  on_linux do
    depends_on "dbus"
    depends_on "glib"
  end

  def install
    args = std_cmake_args + %W[
      ..
      -DPYTHON3_SITEPKG_DIR=#{prefix/Language::Python.site_packages("python3")}
      -DWITH_PERL=OFF
      -DWITH_PYTHON2=OFF
    ]

    mkdir "build" do
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    assert_equal "direct://", pipe_output("#{bin}/proxy 127.0.0.1").chomp
  end
end
