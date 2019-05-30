class NanopbGenerator < Formula
  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.3.9.3.tar.gz"
  sha256 "95b5544f975b6ebf052677caca9c55c5176857aaf3bc11185faf25fd9d8159e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf5f183ac157af998283c8e2ea3e5548bb57a4d28e8b3cfd75572df4f6b17365" => :mojave
    sha256 "298fbe96efa71f53a4bfb7ae92d0e1cf31b8d9749611300ecc02dcefe20be9d8" => :high_sierra
    sha256 "298fbe96efa71f53a4bfb7ae92d0e1cf31b8d9749611300ecc02dcefe20be9d8" => :sierra
    sha256 "298fbe96efa71f53a4bfb7ae92d0e1cf31b8d9749611300ecc02dcefe20be9d8" => :el_capitan
  end

  depends_on "protobuf"
  depends_on "python@2"

  conflicts_with "mesos",
    :because => "they depend on an incompatible version of protobuf"

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
