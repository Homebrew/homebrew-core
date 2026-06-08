class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.36.11.tar.gz"
  sha256 "517b935001f3d43640489cd1aab531a3ed5927fb34379fa6cb1c1a514e9cb8e8"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ffe39568f56c274132445b57eb04377bbb37799611dbbe21bd02c9cc532eaf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ffe39568f56c274132445b57eb04377bbb37799611dbbe21bd02c9cc532eaf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ffe39568f56c274132445b57eb04377bbb37799611dbbe21bd02c9cc532eaf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e93a78dd2905297ab4ae984982582673dea8e5a1122a8990e6fd167699475bf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c6519f898f2a050cc8bb02b08609a658ab4e01d2166c1d832c8b91d065fba52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "829e7d23214131c9a84cd91899bb7a6888d6d7938b18bab9a65f52eaf37078e8"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-go"
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
    assert_path_exists testpath/"proto3.pb.go"
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
