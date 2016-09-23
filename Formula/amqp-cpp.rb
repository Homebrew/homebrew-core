class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"

  stable do
    url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", revision: "ed2ffd3f03f2bba11f8af68c69ec96ab40a5c4b7"
    version "2.6.1"
  end

  head do
    url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", branch: "master"
  end

  needs :cxx11

  depends_on "cmake" => :build
  # Boost required by examples
  depends_on "boost" => :build

  def install
    ENV.cxx11
    system "cmake", "-DBUILD_SHARED=ON", "-DCMAKE_MACOSX_RPATH=1", "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # TODO: use examples as test
  end
end
