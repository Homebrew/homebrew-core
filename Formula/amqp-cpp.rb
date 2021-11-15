class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.15.tar.gz"
  sha256 "21e6ae69dcf535cd1be49b272c3ff019134dddc7d812c0050e5d7bf4e19d0c3b"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bdc4d7d2dd2500415bb158572fa1a3af71e170e83498f002ff0e390fc397f99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78924eacf7c24bfb70d6c3ff041427fbb57b476321e274535e3e5b06e45278e9"
    sha256 cellar: :any_skip_relocation, monterey:       "70d0b0c6181d4bc0bbc1101b9479cc1a57eccb70ccb1cbcd1c2d454e1f346415"
    sha256 cellar: :any_skip_relocation, big_sur:        "b246ab5a6bfb862ee23c89fbf0ebca57eeb99314e219c7c6d9c5a1bb42c81ce2"
    sha256 cellar: :any_skip_relocation, catalina:       "fd48a53d76c86b10729b81bffe84af39435db4c221c9aa0cd021849a6a194f21"
    sha256 cellar: :any_skip_relocation, mojave:         "580fa1d90bac47c4edec0e5ee1b34c1db4953a51fc2ac5ca7022fae2ec0bef3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ed9d8149c436e2e1aa3cc000ec637dd3afd1748845e45c22b4b1c88520f1b7d"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    system "cmake", "-DBUILD_SHARED=ON",
                    "-DCMAKE_MACOSX_RPATH=1",
                    "-DAMQP-CPP_LINUX_TCP=ON",
                    *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <amqpcpp.h>
      int main()
      {
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-o",
                    "test", "-lamqpcpp"
    system "./test"
  end
end
