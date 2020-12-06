class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.16.tar.gz"
  sha256 "9e7959d6ae1d6c817f0ac1e253105ce8d99f55d7821c1b6eaef32bf6879c6f0a"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git"

  bottle do
    sha256 "8ce22907b3d2e06edc6f1d244322ecb1362da13efb946079314765e34459bc36" => :big_sur
    sha256 "f8d85ff96d4da5414b766d3515c837a7c836bbf6f1d491f2c151a8f13a4a684d" => :catalina
    sha256 "17d3a321a78e6eb8b5d9fdd2c5a9abc02867cab29b51f30015d4a191030479e2" => :mojave
    sha256 "9097c3a2158d8b6dc2a4c6413cead843a81c1125e03a787a7edc21a8e3866f6f" => :high_sierra
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
