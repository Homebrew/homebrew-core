class LokiNetwork < Formula
  desc "Private, decentralized, and market-based overlay for the internet"
  homepage "https://loki.network"
  url "https://github.com/loki-project/loki-network/archive/v0.3.1.tar.gz"
  sha256 "a745cd156fd08be575f0e9f2fd56f4d6cde896363103c6f49499c90451021b34"
  head "https://github.com/loki-project/loki-network.git"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => [:build, :test]
  depends_on "abyss"
  depends_on "rapidjson"

  def install
    # set some build time options
    ENV["USE_AVX2"] = "1"
    ENV["USE_LIBABYSS"] = "1"
    ENV["USE_JSONRPC"] = "1"
    # make a subdirectory to store build outputs
    mkdir "#{buildpath}/build"
    # generate ninja build system files
    system "cmake", "-GNinja", "-B", "#{buildpath}/build", "-S", buildpath.to_s, *std_cmake_args
    # build everything
    system "ninja", "-C", "#{buildpath}/build"
    cd "#{buildpath}/build"
    system "ninja"
    # install binaries
    libexec.install [
      "#{buildpath}/build/lokinet",
      "#{buildpath}/lokinet-bootstrap",
      "#{buildpath}/build/dns",
      "#{buildpath}/build/llarpc",
      "#{buildpath}/build/rcutil",
    ]
    # symlink main binaries into #{prefix}/bin
    link "#{libexec}/lokinet", "#{bin}/lokinet"
    link "#{libexec}/lokinet-bootstrap", "#{bin}/lokinet-bootstrap"
    # install library headers
    include.install [
      "#{buildpath}/include/llarp.h",
      "#{buildpath}/include/llarp.hpp",
      "#{buildpath}/include/tuntap.h",
      "#{buildpath}/include/utp.h",
      "#{buildpath}/include/utp_types.h",
    ]
    include.install Dir[
      "#{buildpath}/include/llarp",
      "#{buildpath}/include/tl",
    ]
    # install libraries
    lib.install [
      "#{buildpath}/build/liblokinet-cryptography.a",
      "#{buildpath}/build/liblokinet-platform.a",
      "#{buildpath}/build/liblokinet-static.a",
    ]
  end

  test do
    # run lokinet's self-test binary
    system "#{buildpath}/build/testAll"
  end
end
