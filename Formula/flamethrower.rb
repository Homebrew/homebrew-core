class Flamethrower < Formula
  desc "DNS performance and functional testing utility"
  homepage "https://github.com/DNS-OARC/flamethrower"
  head "https://github.com/DNS-OARC/flamethrower.git"
  depends_on "cmake" => :build
  depends_on "ldns"
  depends_on "libuv"
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "flame"
    end
  end

  test do
    system bin/"flame", "--version"
  end
end
