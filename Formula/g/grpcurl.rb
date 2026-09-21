class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://www.fullstory.com/resources/content/fullstory-engineering-blog/"
  url "https://github.com/fullstorydev/grpcurl/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "bea899ba2f483a951bf40aa05d41e069dd2f7bfe52d2a229717abfdb5620cb7c"
  license "MIT"
  head "https://github.com/fullstorydev/grpcurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "605806917cf60295403f7a448eb73aa3f30e4ec2a77c976aeb3a02cb7ad27b94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d28c43ea91643dc945ea37b820f1d7677ebf1eaca75eafafbbef930281abe8af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d28c43ea91643dc945ea37b820f1d7677ebf1eaca75eafafbbef930281abe8af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "d28c43ea91643dc945ea37b820f1d7677ebf1eaca75eafafbbef930281abe8af"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2a53d7cc70c45181bd570774db9800d7c37357b632efd48c5240042eb8f4d1dd"
    sha256 cellar: :any,                 x86_64_linux:      "a7e35ba2c3a3c3147d5b766575def1a1c8d4edb7330c3e59762bfb382fb0aab4"
  end

  # TODO: unpin go@1.26 when grpcurl supports go 1.27
  # ref: https://github.com/fullstorydev/grpcurl/issues/568
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/grpcurl"
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      package test;
      message HelloWorld {
        string hello_world = 1;
      }
    PROTO
    system bin/"grpcurl", "-msg-template", "-proto", "test.proto", "describe", "test.HelloWorld"
  end
end
