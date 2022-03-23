class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/v1.28.0.tar.gz"
  sha256 "e59ae9ace31c3a84bddf1bc3f04a04c498adb9ea7f9fcde60db91bba33d55171"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d9f6e11bd47c856b87e044a25e47467c7bf9ef5e921ff8474f05feed23488ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d9f6e11bd47c856b87e044a25e47467c7bf9ef5e921ff8474f05feed23488ac"
    sha256 cellar: :any_skip_relocation, monterey:       "887edab7a650f705dc5d42e2f1cdd9f9770bd5b8b21cd1bb8c5f2f87b696589b"
    sha256 cellar: :any_skip_relocation, big_sur:        "887edab7a650f705dc5d42e2f1cdd9f9770bd5b8b21cd1bb8c5f2f87b696589b"
    sha256 cellar: :any_skip_relocation, catalina:       "887edab7a650f705dc5d42e2f1cdd9f9770bd5b8b21cd1bb8c5f2f87b696589b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a12ab9c9f7c4d280391c2b5a0b607fd8f493a2ba3d3d6faba49d77a1653c878f"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-go"
    prefix.install_metafiles
  end

  test do
    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;
      option go_package = "package/test";
      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--go_out=.", "--go_opt=paths=source_relative", "proto3.proto"
    assert_predicate testpath/"proto3.pb.go", :exist?
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
