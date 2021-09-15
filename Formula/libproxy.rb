class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.17.tar.gz"
  sha256 "88c624711412665515e2800a7e564aabb5b3ee781b9820eca9168035b0de60a9"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git"

  bottle do
    sha256 arm64_big_sur: "aa72de0f8f5be2c730d84f20308df804c156e61ff321de0a4b63ba5623517ab7"
    sha256 big_sur:       "d094201c939cfab859da673186809a6c7a24b9a216829b862a1bb53059309d4c"
    sha256 catalina:      "c847a5adafa14e2614351edc46fdf1f8884908912845a9e425ce30925bb55e32"
    sha256 mojave:        "5f6f14d95746e1b4c3328f23c7d9018e7e6a1fab70eba1255276ad89c0c405e5"
    sha256 x86_64_linux:  "2790359c8c7fcad674b377714888b3e98b1dc7c375c4e95f8688a25d3cc239e8"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9"

  on_linux do
    depends_on "dbus"
    depends_on "glib"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    args = std_cmake_args + %W[
      ..
      -DPYTHON3_SITEPKG_DIR=#{lib}/python#{xy}/site-packages
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
