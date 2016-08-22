class NanopbGenerator < Formula
  desc "ANSI C library for encoding and decoding Protocol Buffer messages"
  homepage "https://koti.kapsi.fi/jpa/nanopb/docs/index.html"
  url "https://koti.kapsi.fi/~jpa/nanopb/download/nanopb-0.3.6.tar.gz"
  sha256 "3e6d5d4971dc11845261ddca7e1c67b96eabf95e839327c7d8ed6f07412edab7"

  bottle do
    cellar :any_skip_relocation
    sha256 "e48c213f1af09ef52f38a874991dcd5bc6e2fe86e5404a7b272160d4a9cea5cb" => :el_capitan
    sha256 "1390bb0c55b7b6a278588d3648b1ca6441fd2294d6f62d34e8552405710093eb" => :yosemite
    sha256 "cf5dabc592b4c8d4b338915dcbc1bddb9a000fe0c087bd03c2f13ff0981c2edd" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "protobuf"

  resource "protobuf-python" do
    url "https://pypi.python.org/packages/source/p/protobuf/protobuf-2.6.0.tar.gz"
    sha256 "b1556c5e9cca9069143b41312fd45d0d4785ca0cab682b2624195a6bc4ec296f"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    resource("protobuf-python").stage do
      system "python", "setup.py", "install", "--prefix=#{libexec}"
    end

    Dir.chdir "generator"

    system "make", "-C", "proto"

    libexec.install "nanopb_generator.py", "protoc-gen-nanopb", "proto"

    (bin/"protoc-gen-nanopb").write_env_script libexec/"protoc-gen-nanopb", :PYTHONPATH => ENV["PYTHONPATH"]
    (bin/"nanopb_generator").write_env_script libexec/"nanopb_generator.py", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    (testpath/"test.proto").write <<-PROTO.undent
      syntax = "proto2";

      message Test {
        required string test_field = 1;
      }
    PROTO
    system Formula["protobuf"].bin/"protoc",
      "--proto_path=#{testpath}", "--plugin=#{bin}/protoc-gen-nanopb",
      "--nanopb_out=#{testpath}", testpath/"test.proto"
    system "grep", "test_field", testpath/"test.pb.c"
    system "grep", "test_field", testpath/"test.pb.h"
  end
end
