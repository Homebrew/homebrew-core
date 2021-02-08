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
    sha256 catalina:    "108518e716f6e752b93e30dd54f597f303e2b87b65399460e4d954e12254c8a8"
    sha256 mojave:      "9ba28b38c5529f14e36c0de4231152431c3de02c8fd375f09375bceeaddd6088"
    sha256 high_sierra: "ddacb6bb51d546a4d3a5d45b01cf25588a9a7d644fdb5747e99179278e115459"
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
