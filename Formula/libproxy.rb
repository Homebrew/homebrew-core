class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.17.tar.gz"
  sha256 "88c624711412665515e2800a7e564aabb5b3ee781b9820eca9168035b0de60a9"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git"

  bottle do
    sha256 "f3d87ec7e6d5ee417691c26a776886216436ab1b190bf6674c8dede66da0ec00" => :big_sur
    sha256 "868bf3c73324f4e9275dfe482be9b23a251563ba12f51a7c9d2df678fc4b439b" => :arm64_big_sur
    sha256 "76cde5260a836b3ce6c3ed0d1e588c29159018d702866209fe36c0be24995603" => :catalina
    sha256 "69e02ca786abaa1fb825995039e67750f2315a8d93206c15ec60e839830c0bf7" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "python@3.9"

  uses_from_macos "perl"

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
