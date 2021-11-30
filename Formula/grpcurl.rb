class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.8.5.tar.gz"
  sha256 "1a9612560b2da18d50f0a46e9f2f5a7e5a13c4bb1ccef15ba65cb0c37335342b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa1d9cb2fbe10d32cfd3c8054470a6fa9252398b8d0ee8173d6472969a8cc87a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a8dd3ae573f6d2ccfa345ad82c65b6d619d499d83dc92737f18b4281fb3db24"
    sha256 cellar: :any_skip_relocation, monterey:       "f34de76d162ca64e0ad367267115f9de56649727dcc59d15a6187476f0d59aef"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebf419ea7d01fd13e6e6e274a7aed487d41a979f267630838228fe718b7fdc40"
    sha256 cellar: :any_skip_relocation, catalina:       "e4ccd7f8496238cd23919166ca8721471732919af8b4f21abceb9feef8561003"
    sha256 cellar: :any_skip_relocation, mojave:         "f2fe91c9954c1c5e2797c9eb10557a3ddea090c0b14cc1623f237a93038161e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46eb83d219deb562546cf83106693d6b10b695060e6bc557e18c41506ef60a9a"
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
