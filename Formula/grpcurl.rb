class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.8.6.tar.gz"
  sha256 "18b457f644baabeef0de350596dd8d23563586ee94a3ed3cb290063e097ab934"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69c6ef510f421c1363eec22620c089a015c52e53844afb9072b518704a5e4070"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f906e658d4519e95eb37b43b840c76d16f19b6e9865c34314be8e2c63ddbf46"
    sha256 cellar: :any_skip_relocation, monterey:       "f0a2db8478055277328b6346fc57204a5c251441c63814bda46672f8307413d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a43b1767f708398f73b3e647a0f7915717ff10ac340cffcf7e93c261e375549"
    sha256 cellar: :any_skip_relocation, catalina:       "4d9f35fec2785e437dccb9c5836799ab90d6d2439cf011846ef9171676491575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02adce763e2fd45ea99627ef172416d3534db2c51ab5138c6ef9cd32c8a9fdc2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/grpcurl"
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      package test;
      message HelloWorld {
        string hello_world = 1;
      }
    EOS
    system "#{bin}/grpcurl", "-msg-template", "-proto", "test.proto", "describe", "test.HelloWorld"
  end
end
