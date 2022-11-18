class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/v1.28.1.tar.gz"
  sha256 "df0b3dceeff0e1b6d029e60f076edd0d852cb8f3c2fe4fe3fe40164f16ec9b6b"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac0b2d7f4f50e8400be8bb27486a33dbbcdec1358ba7ac4a4e8436561d158aa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d136978460dd87b8a0b85015081ccc4a5b1cdb3a3651a67e835ff08c54f1ef94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d136978460dd87b8a0b85015081ccc4a5b1cdb3a3651a67e835ff08c54f1ef94"
    sha256 cellar: :any_skip_relocation, ventura:        "25e91ecfa07dedca75170da086bbea7e789486b5bf73215ea638de92b792bd9b"
    sha256 cellar: :any_skip_relocation, monterey:       "73b37dbb28c01533b89a2828d6a3ea25036e8b091ca2a079a7411801e313d628"
    sha256 cellar: :any_skip_relocation, big_sur:        "73b37dbb28c01533b89a2828d6a3ea25036e8b091ca2a079a7411801e313d628"
    sha256 cellar: :any_skip_relocation, catalina:       "73b37dbb28c01533b89a2828d6a3ea25036e8b091ca2a079a7411801e313d628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19c8d17a42340e69455184e35902e123075e9631d032739f690c90bc984cda6c"
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
