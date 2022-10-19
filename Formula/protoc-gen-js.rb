class ProtocGenJs < Formula
  desc "JavaScript Protocol Buffers generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v3.21.2.tar.gz"
  sha256 "35bca1729532b0a77280bf28ab5937438e3dcccd6b31a282d9ae84c896b6f6e3"
  license "BSD-3-Clause"

  depends_on "bazel" => :build
  depends_on "protobuf" => :test

  def install
    # LICENSE-asserts.md is Apache-2.0 license for asserts.js, but this is not
    # used by the generator. So, we remove license to avoid installing it.
    (buildpath/"LICENSE-asserts.md").unlink

    bazel_args = %W[
      --jobs=#{ENV.make_jobs}
      --compilation_mode=opt
      --verbose_failures
    ]
    if OS.linux?
      # Need to remove shim path as bazel clears Homebrew's environment variables
      env_path = "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
      bazel_args += %W[
        --action_env=PATH=#{env_path}
        --host_action_env=PATH=#{env_path}
      ]
    end
    system "bazel", "build", *bazel_args, "//generator:protoc-gen-js"
    bin.install "bazel-bin/generator/protoc-gen-js"
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    system "protoc", "test.proto", "--js_out=."
    assert_predicate testpath/"test.js", :exist?
    assert_predicate testpath/"testcase.js", :exist?
  end
end
