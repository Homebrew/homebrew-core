class NanopbGenerator < Formula
  desc "ANSI C library for encoding and decoding Protocol Buffer messages"
  homepage "https://koti.kapsi.fi/jpa/nanopb/docs/index.html"
  url "https://koti.kapsi.fi/~jpa/nanopb/download/nanopb-0.3.6.tar.gz"
  sha256 "3e6d5d4971dc11845261ddca7e1c67b96eabf95e839327c7d8ed6f07412edab7"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "8cf34bd08291c4d9baea1c052b36a60a815faa8e507bcae6003d295878dafdfd" => :el_capitan
    sha256 "514208bb4b9292a232bd51f76dca1d8a6be230b2d8d4b50ee37e01cd05baf39e" => :yosemite
    sha256 "e03430f36c4225535017d0600637d99e68aad20d55c58cae7f86f2961fc6e433" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "protobuf"

  resource "protobuf-python" do
    url "https://pypi.python.org/packages/14/3e/56da1ecfa58f6da0053a523444dff9dfb8a18928c186ad529a24b0e82dec/protobuf-3.0.0.tar.gz"
    sha256 "ecc40bc30f1183b418fe0ec0c90bc3b53fa1707c4205ee278c6b90479e5b6ff5"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
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
