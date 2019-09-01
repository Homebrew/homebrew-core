class NanopbGenerator < Formula
  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.3.9.3.tar.gz"
  sha256 "95b5544f975b6ebf052677caca9c55c5176857aaf3bc11185faf25fd9d8159e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa46a4150df33670da03c430f0159b8481d10872b2786e8a177cb76170029db5" => :mojave
    sha256 "fa46a4150df33670da03c430f0159b8481d10872b2786e8a177cb76170029db5" => :high_sierra
    sha256 "f9073ddbdcffb922e3f0137fe04d52ce9a4ce5a937fd9408c14a6e31665d8489" => :sierra
  end

  depends_on "protobuf"
  depends_on "python"

  conflicts_with "mesos",
    :because => "they depend on an incompatible version of protobuf"

  def install
    cd "generator" do
      system "make", "-C", "proto"
      inreplace "nanopb_generator.py", %r{^#!/usr/bin/env python$},
                                       "#!/usr/bin/env python3"
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
