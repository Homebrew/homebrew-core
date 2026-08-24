class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.16.3",
      revision: "44e576fb77ee78ff259a5915b343ca1c3e65fcf9"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "514f7c05817f41ef47de17c1297020bfd7a1bf8224327d948f1d988e3f3a1839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72a8af43887d8042fcc7dd7475980b4fa9da8d97e583fb354097b54f052952b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8be1584528b95632337eec28dbbbc43235070e7129e812385857571c65a130a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "980eae414872b20e36b4607a62fd013a75d8f4bd9ca6986191c46b7a74eadafe"
    sha256 cellar: :any,                 arm64_linux:   "92d1bca55e9eb0427ff8b18611f2225570c2c99227ef2ad0fa57cb13a63814d9"
    sha256 cellar: :any,                 x86_64_linux:  "9cf5e23a6be91f11390a6819e7784a4d643e6bf2cc3a43f0f23344db140acdca"
  end

  depends_on "ldc" => :build

  def install
    system "make", "ldc"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = spawn bin/"dcd-server", "-p", port.to_s
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system bin/"dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
