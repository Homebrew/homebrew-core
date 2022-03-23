class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/v1.28.0.tar.gz"
  sha256 "e59ae9ace31c3a84bddf1bc3f04a04c498adb9ea7f9fcde60db91bba33d55171"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08363c023c5841eff91cbea29452c902b615516196fcb68d826b4dc877d2e3d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "577196328ed1d829d999d7eb7a1fbdcd340831619b5e53db1e9ff880bb0514cb"
    sha256 cellar: :any_skip_relocation, monterey:       "eb5cf886304f8d4079b81e5f698f2999b9c1f1b9d63abe7a156a21f9dc620baa"
    sha256 cellar: :any_skip_relocation, big_sur:        "3990c0be0447ef4cebc03575c737a01a8a7af9e3766cb014addc4c932eeb4228"
    sha256 cellar: :any_skip_relocation, catalina:       "3990c0be0447ef4cebc03575c737a01a8a7af9e3766cb014addc4c932eeb4228"
    sha256 cellar: :any_skip_relocation, mojave:         "3990c0be0447ef4cebc03575c737a01a8a7af9e3766cb014addc4c932eeb4228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf23c02b98cfea6ed4a0d293a6f669b61fa11c6a04f5288ae6d910b20c0a8f4c"
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
