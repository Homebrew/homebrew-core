class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.13.tar.gz"
  sha256 "d610bc0ef81a18ba418d759c5f4f87bf7102229a9153fb397d7d490987330ffd"
  head "https://github.com/libproxy/libproxy.git"

  bottle do
    sha256 "327eec75d177ec2299b84b8f9dbc85769ac6ec806f7fff9079c42596e06025cc" => :sierra
    sha256 "68aaba945b87320573bff0c536e607cdedc93a90b7b90530c62ca5a84c198009" => :el_capitan
    sha256 "9f5bd17d93068b1e4074f72214dd5b9e850ac65a5ed0972f3bb0358fabec1883" => :yosemite
    sha256 "8c8a57a319799b3277f503142ef124a34b5d12866dffbffad299fd4b68fba572" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      # build tries to install to non-standard locations for Python bindings
      system "cmake", "..", "-DWITH_PYTHON=no", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_equal "direct://", pipe_output("#{bin}/proxy 127.0.0.1").chomp
  end
end
