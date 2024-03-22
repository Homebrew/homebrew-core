class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/refs/tags/v1.8.9.tar.gz"
  sha256 "962fe7d3da7653519d2975e130244af9286db32041b0745613aebf89949a9009"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "552935a3a42486550742866a814d59b9939c96ded35729b994f83a5d434457c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9583f39476fb1d1b740feb48a285281ec6309f1d0bc5bb73014e52533004621c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd99bef6ce4a47666fb27e618201c1c2663cbe88001e4e491e5c94f878fb62e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "617641e6227ac00767a3672f76fdee8bb5e99d82d14050293ac62a9ac5d61c43"
    sha256 cellar: :any_skip_relocation, ventura:        "81705e0eebe0228a7a58047419d73a295ae61c4dd2fed218ae68f51948e61e2a"
    sha256 cellar: :any_skip_relocation, monterey:       "13755998f96a7b09e674b93a434160ae4362a1b99ebf4d29ba0496b5294e7667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e1c96a3116b1eb7d323b406a504bcf1556aacc3d5b7ae6b600eec5596e40e9"
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
