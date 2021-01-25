class NanopbGenerator < Formula
  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.4.tar.gz"
  sha256 "56fb6efb17824f09fd64c509cc6bbe0f44919137f8143a8613e1194cd4782374"
  license "Zlib"

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e21886b97c90e974ad0703192f26ebd46b434dd0c5628d2c212a2281bc10b093" => :big_sur
    sha256 "2bf71e3731cd20856320911e2f93faeb1e08f4dc833c9d24af1ac7f0a7b30f43" => :arm64_big_sur
    sha256 "6e8adb5331cae1497b14da6367cfbfc4b2231d06738c58402ab978f76834cbd9" => :catalina
    sha256 "e64b44fbf7a8dc521871cc366962195eaa9d73db5da8d138ff1b71f4a6d92ccd" => :mojave
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
