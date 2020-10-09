class NanopbGenerator < Formula
  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.3.tar.gz"
  sha256 "91b4be33691dc1532d94b56f308743b8a07d209126b7fe21f98f8fdadd8edb95"
  license "Zlib"
  revision 1

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4fdcfd8b50714132f4c53b99408c1df4e8f74ecd562ddf38e97828c11a459db2" => :catalina
    sha256 "9aa621fbc7be7e43fff5622ebba5add56fdabb033088aabb3157aa7cbec60d9d" => :mojave
    sha256 "1083d15a2b07c7f8c5e3666fcebb08fa655a48114b31b2bdc2c811c832550002" => :high_sierra
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
