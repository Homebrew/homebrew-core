class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/v1.5.2.tar.gz"
  sha256 "f8b25ab86738864b1f2e3128e8badab581510fa8085ff5ca9bb980d317334c46"
  license "MIT"

  livecheck do
    url "https://github.com/nanomsg/nng.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2d9e7358d8ab743e62129359d95a0a2d21cff3634cb7bfc8f292dc0258b494e3"
    sha256 cellar: :any,                 big_sur:       "589abea5f8ba1c541582fe61559743b428b37674ff61ddfe0848903c6dd6ed77"
    sha256 cellar: :any,                 catalina:      "c447a6e93b03585ccf3aea04c47c462a511909887f71cbd41181ed637e2f6d14"
    sha256 cellar: :any,                 mojave:        "b4c6e981cc319d9e0039fd64cdeb2a9c7f2a1573229de71eb792000eca09553f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6962f4662614ccb5a497f432548aeae3310f8700b14d01b106f94f0a2a04c15"
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
