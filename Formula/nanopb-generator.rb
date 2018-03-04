class NanopbGenerator < Formula
  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.3.9.tar.gz"
  sha256 "f6fe05441150bf158c2adfec29fa8206785bbb6c3dcd4a3ddbafcf8f9ad9f251"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "030d054005b5167d327d8cd95df7e04a8bfdc66dd2354890babafa11c197a18e" => :high_sierra
    sha256 "030d054005b5167d327d8cd95df7e04a8bfdc66dd2354890babafa11c197a18e" => :sierra
    sha256 "a5f6e9fab63d0ecf3f7f52f1191ff16b7e01d2de063b9163462e4d5a49082b00" => :el_capitan
  end

  depends_on "python@2" if MacOS.version <= :snow_leopard
  depends_on "protobuf"

  def install
    cd "generator" do
      system "make", "-C", "proto"
      inreplace "nanopb_generator.py", %r{^#!/usr/bin/env python$},
                                       "#!/usr/bin/python"
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
    system "grep", "test_field", testpath/"test.pb.c"
    system "grep", "test_field", testpath/"test.pb.h"
  end
end
