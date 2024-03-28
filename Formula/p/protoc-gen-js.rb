class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v3.21.2.tar.gz"
  sha256 "35bca1729532b0a77280bf28ab5937438e3dcccd6b31a282d9ae84c896b6f6e3"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc2ba4ee9b1a566ee47dafd96f73dce89b383291c1504950aad5334c7945d661"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "596914c981706cef366b362d4f514a35b6697baeb7646f8d323779ac0a1167a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37e7fbdf46b8b8a5df2d7f21458bf8bb613ed96d5ce0599b7ecd7038a691938e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a444f2d40d5032e35985f1d9f10994fb69171bd318fe4ad43c01292cc66bfb94"
    sha256 cellar: :any_skip_relocation, ventura:        "7d18411c33bca80e42e2ab2ee14003d5bda1fc185192f656716bb2491ce58528"
    sha256 cellar: :any_skip_relocation, monterey:       "82495e5cd063520c537b811bb6a14c11371c7d540b4f31412074a55ff4883a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb375b65b3a2fbfa936054f5899c0a9ac5324c027475133d3b5ed36d5da2f055"
  end

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
