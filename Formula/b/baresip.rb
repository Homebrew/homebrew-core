class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "047c1785413b62aa0e9b16f4ce3336110c2cda3ab7eef1a01e29d0ed343c0118"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "3da4f6e898bb7e3116dcf2ff693609b4a1017d1392d8291303418469247bcbe9"
    sha256 arm64_sequoia: "17f36c97cebd725b5e1831545686fc103449f2a3d9a1a2fe91ce6e549a5d4a5f"
    sha256 arm64_sonoma:  "3e2d7dc42fc36ee0299542ce5827b8bde280a39a22dd06ab509818bf1a359cd2"
    sha256 sonoma:        "bc939b3c098216d21dc88eceb7444103171db6a7d6caf6de4737ed5530653b3d"
    sha256 arm64_linux:   "46de8dd784fbd968e1a68a0144e63a779cb954c16ed77b952d54d1f92ce5ccd5"
    sha256 x86_64_linux:  "cd8d57b1e215ea57b74a11426e8a860f014cb1f37ddef35f722ecbe343b13268"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}/re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
