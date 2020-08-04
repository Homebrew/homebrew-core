class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.7.0.tar.gz"
  sha256 "0999aa1516deb2575bdc1d11d3a5dd8494a5aa25fa899e6afc245c3ccc2bbeb5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b141489fbe726a3f534d86a0f53af867a7b4bff1a92c1c8305e73d5e0fb6f87a" => :catalina
    sha256 "99121cc3d5c1b521dc69511609d1214b4c297a136902e08384161418ceb320dd" => :mojave
    sha256 "c62f76f233dfa5686d3018b351436d469ce142c5714cbe67960478c2a5e4f640" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}", "./cmd/grpcurl"
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
