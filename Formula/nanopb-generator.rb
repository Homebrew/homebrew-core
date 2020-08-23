class NanopbGenerator < Formula
  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.2.tar.gz"
  sha256 "3fae3a8efb61cf06124732fc775088389f259f0c8d85f1ca3330da295282f912"

  bottle do
    cellar :any_skip_relocation
    sha256 "42459566535f189ab887bc2d8f2a2cb0bdc6b262b56ba9306434d410d2af8c38" => :catalina
    sha256 "6bbf097a240a30f9a4560a036d46dc0f10c09f04ca05a45a67430dda911e3397" => :mojave
    sha256 "6bbf097a240a30f9a4560a036d46dc0f10c09f04ca05a45a67430dda911e3397" => :high_sierra
  end

  depends_on "protobuf"
  depends_on "python@3.8"

  conflicts_with "mesos",
    because: "they depend on an incompatible version of protobuf"

  def install
    cd "generator" do
      system "make", "-C", "proto"
      inreplace "nanopb_generator.py", %r{^#!/usr/bin/env python3$},
                                       "#!/usr/bin/env #{Formula["python@3.8"].opt_bin}/python3"
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
