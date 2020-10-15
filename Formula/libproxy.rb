class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.15.tar.gz"
  sha256 "18f58b0a0043b6881774187427ead158d310127fc46a1c668ad6d207fb28b4e0"
  license "LGPL-2.1"
  revision 2
  head "https://github.com/libproxy/libproxy.git"

  bottle do
    sha256 "fbb6b461e2abfbd8f3c117c64410827fac0759cefab76cbccd4051f9d5b98d9c" => :catalina
    sha256 "74b3f2231eaaaf6ca8cbcb7868b0cb71a62ed4228b1c6fb81ce1b9548819cdb6" => :mojave
    sha256 "bf36cc90d464f46a70aca6407df2ea7c7b1b325d29346de3813298016cd0c324" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8"

  uses_from_macos "perl"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
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
