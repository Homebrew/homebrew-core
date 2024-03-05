class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "21661d7634e3f783b015b93ceafc0261f2f02a270799bac871602c3a2172cfbe"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b44d95ef619de8304e7e448c041659b9bfd1bda1004ea71b39eb6f024af05797"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b44d95ef619de8304e7e448c041659b9bfd1bda1004ea71b39eb6f024af05797"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b44d95ef619de8304e7e448c041659b9bfd1bda1004ea71b39eb6f024af05797"
    sha256 cellar: :any_skip_relocation, sonoma:         "4932f0be514789162278c9866f611aefbd0bc12daf91085ea643269e8f78d05f"
    sha256 cellar: :any_skip_relocation, ventura:        "4932f0be514789162278c9866f611aefbd0bc12daf91085ea643269e8f78d05f"
    sha256 cellar: :any_skip_relocation, monterey:       "4932f0be514789162278c9866f611aefbd0bc12daf91085ea643269e8f78d05f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f6cf5e13a71565be22b62df98e9187a8842114029d924c0dc0278c6f66db404"
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
