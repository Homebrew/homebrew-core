class NanopbGenerator < Formula
  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.5.tar.gz"
  sha256 "7efc553d3d861bceb1221f79d29b03e4353f0df2db690cbced0f4a81882d95fd"
  license "Zlib"

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e52f0be723f759324edec9d1f9fcffafbe7c84f2d3547d592d606f2f330b061"
    sha256 cellar: :any_skip_relocation, big_sur:       "3619dec5a99713f7b2afcccb631e04b4a6cfd4cf07b140fda95d32e7405038a1"
    sha256 cellar: :any_skip_relocation, catalina:      "fc7ebaa9f8ba1b2360c5cdfe36d08db127abfce401bbecba1797b1bf2047a236"
    sha256 cellar: :any_skip_relocation, mojave:        "b9c33b74a6363131e3e0e9ffc1e91a71a53433e470c78703726ccbd7e2050caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbbb4f7447e0de14a0c0f8ddbf82d81e29001ae2493482e79c87d4cebaa555f1"
    sha256 cellar: :any_skip_relocation, all:           "dbbb4f7447e0de14a0c0f8ddbf82d81e29001ae2493482e79c87d4cebaa555f1"
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
