class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nng.nanomsg.org/"
  url "https://github.com/nanomsg/nng/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "439241ca7afd059e2c5635491e430e37b591430c25aa57c0ba07995c3fbdffa6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6a23df4b783b452c7376eb62aa6b43e0ead2a3139522f14a2887b72a738bb0c5"
    sha256 cellar: :any, arm64_tahoe:       "3301e01ae1d82fb4962a41be1a9bbcaddf24aa366fd182f009f26c434557996c"
    sha256 cellar: :any, arm64_sequoia:     "d1efd2236dee484683621428f4c8b569c36d8762b18fb948b18297999fb7bc79"
    sha256 cellar: :any, arm64_linux:       "7e13311e7423747d8bac5e1420817f807d4bb7a29f06d6450c1a9de91ff716d8"
    sha256 cellar: :any, x86_64_linux:      "6c7589529cc1b258a90f69c28015a5585e286fd52c1edbf56d8cf7ffb9a31527"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  allow_network_access! :test

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DNNG_ENABLE_DOC=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
