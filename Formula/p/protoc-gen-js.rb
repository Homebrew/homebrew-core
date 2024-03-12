class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v3.21.2.tar.gz"
  sha256 "35bca1729532b0a77280bf28ab5937438e3dcccd6b31a282d9ae84c896b6f6e3"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  depends_on "bazelisk" => :build
  depends_on "protobuf@21"

  def install
    env_path = "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    args = %W[
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
    ]
    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *args, "//generator:protoc-gen-js"
    bin.install "bazel-bin/generator/protoc-gen-js"
  end

  test do
    (testpath/"person.proto").write <<~EOS
      syntax = "proto3";

      message Person {
        int64 id = 1;
        string name = 2;
      }
    EOS
    system Formula["protobuf@21"].bin/"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_predicate testpath/"person_pb.js", :exist?
    refute_predicate (testpath/"person_pb.js").size, :zero?
  end
end
