class NanopbGenerator < Formula
  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.4.tar.gz"
  sha256 "56fb6efb17824f09fd64c509cc6bbe0f44919137f8143a8613e1194cd4782374"
  license "Zlib"
  revision 1

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df771d601248c905f5da80f48cbac0c50d636fb0cb7d81e0fb655c9cda15ac87"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee9dd36ebeaaec92ff043fdf57f5ef380da93b7dfac6295c5d37b600da5f314d"
    sha256 cellar: :any_skip_relocation, catalina:      "9ad5efdcf92dde1e8fd3b1757b404840daada3eaed6dc1eb73be2de253542c7b"
    sha256 cellar: :any_skip_relocation, mojave:        "4df510967a8882043092a084a019f27ef3b3c5730ad677ff777b0afdd86cace6"
  end

  depends_on "protobuf"
  depends_on "python@3.9"

  conflicts_with "mesos",
    because: "they depend on an incompatible version of protobuf"

  def install
    cd "generator" do
      system "make", "-C", "proto"
      inreplace "nanopb_generator.py", %r{^#!/usr/bin/env python3$},
                                       "#!/usr/bin/env #{Formula["python@3.9"].opt_bin}/python3"
      libexec.install "nanopb_generator.py", "protoc-gen-nanopb", "proto"
      bin.install_symlink libexec/"protoc-gen-nanopb", libexec/"nanopb_generator.py"
    end
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto2";

      message Test {
        required string test_field = 1;
      }
    EOS

    system Formula["protobuf"].bin/"protoc",
      "--proto_path=#{testpath}", "--plugin=#{bin}/protoc-gen-nanopb",
      "--nanopb_out=#{testpath}", testpath/"test.proto"
    system "grep", "Test", testpath/"test.pb.c"
    system "grep", "Test", testpath/"test.pb.h"
  end
end
