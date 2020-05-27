class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://github.com/NeoRaider/fastd"
  url "https://github.com/NeoRaider/fastd/releases/download/v19/fastd-19.tar.xz"
  sha256 "6054608e2103b634c9d19ecd1ae058d4ec694747047130719db180578729783a"
  head "https://github.com/NeoRaider/fastd.git"

  bottle do
    cellar :any
    sha256 "fea38ac2d1095bd0ec97fa55b3cadaea3e80c8f2ab3617f2af4b6e3066fc557e" => :catalina
    sha256 "abade335b936258e80d713d939b1b0067000cc9b1ae7d3b94be97cd1775bfc19" => :mojave
    sha256 "d4b19c43e7ad0b84282de0255b7b03ca124f1df7ad7eb1b8b39fb3f87f3dacd0" => :high_sierra
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
