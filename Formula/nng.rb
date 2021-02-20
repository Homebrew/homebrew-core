class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/v1.4.0.tar.gz"
  sha256 "e0af76aff291c670d091a07a4e71febf7b7a254f1ab5939f9464ccbd8f8aa2ba"
  license "MIT"

  livecheck do
    url "https://github.com/nanomsg/nng.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 big_sur:  "116a7c22766d5db5ae416e06ea53f15e0511520319a7500e2b5c7cc28198c166"
    sha256 catalina: "fd68af7c0f9cabe18c673c60e92f4252d10e91b6f979c8bb625d7c48698e1655"
    sha256 mojave:   "ca12fdc7635dac1cc2b8551ca5d72b51d01a8b4ab775bc6555cc6aaf048c7f20"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-GNinja", "-DNNG_ENABLE_DOC=ON", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}/nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}/nngcat --req --connect #{bind} --format ascii --data brew")
    assert_match(/home/, output)
  end
end
