class NanopbGenerator < Formula
  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.1.tar.gz"
  sha256 "bae4202983c39d7546a0a464ada00faf9263ac186d8426f0497fefab0abb5eea"

  bottle do
    cellar :any_skip_relocation
    sha256 "328a292499b7158cbd899ca2499563e6c2126c55f497ced7bd5e805938a7a208" => :catalina
    sha256 "328a292499b7158cbd899ca2499563e6c2126c55f497ced7bd5e805938a7a208" => :mojave
    sha256 "328a292499b7158cbd899ca2499563e6c2126c55f497ced7bd5e805938a7a208" => :high_sierra
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
    system "grep", "Test", testpath/"test.pb.c"
    system "grep", "Test", testpath/"test.pb.h"
  end
end
