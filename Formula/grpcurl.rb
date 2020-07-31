class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.7.0.tar.gz"
  sha256 "0999aa1516deb2575bdc1d11d3a5dd8494a5aa25fa899e6afc245c3ccc2bbeb5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b98a32b63590b58f1e274f07bd38cc6593403cb472adeb40819664825d70bd2b" => :catalina
    sha256 "a6124dd05fb27cdfe7d645e8f3657aa977702111336d0ccc4aebafc2936470d2" => :mojave
    sha256 "c6973360fa628aabc725bfaa45b262e7a8656f3d218a0e84b4a98f26e5ac6197" => :high_sierra
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
