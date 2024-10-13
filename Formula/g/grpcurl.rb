class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "4bc60a920635929bdf9fa9bb5d310fe3f82bccd441a1487680566694400e4304"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c5809c9dd0340f5a8a58850e2aedf505a26ddd3739fe719d00d6fc5a38f10875"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efd68b0efcb47dad3279e83287d949c29a7006b30b6fd0f76703a1b493ea332d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa42f3862cb0797efa42180319ce25ea635cfa3a682d1e359da1879323d43a54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ace40839f0ecf9bedaeef3dc0ac75efcc872ab3c297f6f2cd3125d325a4fa5ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "b776c9fec3fc86a992c59ef7cdd5a0ce3c9fd2dc47fe93baef60463ac300cff6"
    sha256 cellar: :any_skip_relocation, ventura:        "653f584dafa843f1f3b4306e905090f91a6d3d275eccf49d3931eabf8540bbd4"
    sha256 cellar: :any_skip_relocation, monterey:       "e62d02e7c297595290140eca5fae2b725089338e41891bae1816581a44abccca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d18d53a4e37806ac19e5e934f8798793d09595fdac978dda5b9581db675e0f2"
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
    system bin/"grpcurl", "-msg-template", "-proto", "test.proto", "describe", "test.HelloWorld"
  end
end
