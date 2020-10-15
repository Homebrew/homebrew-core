class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://github.com/NeoRaider/fastd"
  url "https://github.com/NeoRaider/fastd/releases/download/v19/fastd-19.tar.xz"
  sha256 "6054608e2103b634c9d19ecd1ae058d4ec694747047130719db180578729783a"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/NeoRaider/fastd.git"

  bottle do
    cellar :any
    sha256 "37f5ce56da71775cec3a8d1441a13d5f9ee8c3e903a3605867f46ca6452c8900" => :catalina
    sha256 "94eb461f5c5cbbadf1a3eec6c647ca34e9bf7897efe37c22c8f4c4eb045311e9" => :mojave
    sha256 "ec6bf6837faa5900e5e13380ea47b22d1ed317b0c4b7e7282d4c9b467ec1a125" => :high_sierra
  end

  depends_on "bison" => :build # fastd requires bison >= 2.5
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsodium"
  depends_on "libuecc"

  def install
    mkdir "build" do
      system "cmake", "..", "-DENABLE_LTO=ON", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/fastd", "--generate-key"
  end
end
