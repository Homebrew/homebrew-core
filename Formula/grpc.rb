class Grpc < Formula
  desc "Google's open-source RPC framework, based on protocol buffers."
  homepage "http://www.grpc.io/"
  head "https://github.com/grpc/grpc.git"

  stable do
    # The script run below, which is no longer needed in versions newer than
    # 1.0.1, requires fun sed things, which don't seem to work with mac's sed.
    url "https://github.com/grpc/grpc/archive/v1.0.1.tar.gz"
    sha256 "efad782944da13d362aab9b81f001b7b8b1458794751de818e9848c47acd4b32"
    depends_on "gnu-sed" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"
  depends_on "openssl"

  def install
    ENV["prefix"] = prefix
    ENV["HAS_SYSTEM_PROTOBUF"] = "true"
    ENV["HAS_PKG_CONFIG"] = "true"
    ENV["HAS_EMBEDDED_PROTOBUF"] = "0"

    if build.stable?
      # This isn't an issue after version 1.0.1. In version 1.0.1, some
      # compiled protobufs are checked in. Those protobufs are compiled with
      # an older version of protoc than the one in homebrew. Moreover, the
      # script to build these files is broken, which this inreplace fixes.
      inreplace "tools/codegen/extensions/gen_reflection_proto.sh" do |s|
        s.gsub! "bins/opt/protobuf/protoc", "protoc"
        s.gsub! "sed", "gsed"
        s.gsub! /\{INCLUDE_DIR.+?\}/, "{INCLUDE_DIR}"
        s.gsub! 'INCLUDE_DIR="grpc++/ext"', 'INCLUDE_DIR="grpc++\\/ext"'
      end
      system "make", "grpc_cpp_plugin"
      system "tools/codegen/extensions/gen_reflection_proto.sh"
    end
    system "make", "install"
  end

  test do
    system "#{bin}/grpc_cpp_plugin < /dev/null"
  end
end
