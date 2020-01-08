class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.15.tar.gz"
  sha256 "18f58b0a0043b6881774187427ead158d310127fc46a1c668ad6d207fb28b4e0"
  revision 1
  head "https://github.com/libproxy/libproxy.git"

  bottle do
    sha256 "85c0981635696e9160b6f69ed4396609a4542ad478fdd3ac6b5b43b3c25bee07" => :catalina
    sha256 "2bd92529540425a786f17b2b2cc10423394c53a6120bbfa7a8d1df29b0617818" => :mojave
    sha256 "1da068be3ea931eda7ac2f58c8db57d9169d299bc5d57c70b8a455decd351931" => :high_sierra
    sha256 "e848c71f0cdd15d30a2f8003188883f4cf395034447d8b8db4909db5d51904ea" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "python"

  def install
    args = std_cmake_args + %W[
      ..
      -DPYTHON3_SITEPKG_DIR=#{lib}/python2.7/site-packages
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
