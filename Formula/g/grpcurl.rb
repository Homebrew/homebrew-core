class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "bb555087f279af156159c86d4d3d5dd3f2991129e4cd6b09114e6851a679340d"
  license "MIT"
  head "https://github.com/fullstorydev/grpcurl.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f0fd06ad531b223c2059d6163ad171e27b62942634eeceadd63f1092cb568bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b6be18c234287de07dc328bcf18ab337dc9b89a477e20110546d7615bd31815"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b6be18c234287de07dc328bcf18ab337dc9b89a477e20110546d7615bd31815"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b6be18c234287de07dc328bcf18ab337dc9b89a477e20110546d7615bd31815"
    sha256 cellar: :any_skip_relocation, sonoma:        "73e6d2427885ab08ae862f8e43be8b3d988917a1fdc722026cdd587be1629d1e"
    sha256 cellar: :any_skip_relocation, ventura:       "73e6d2427885ab08ae862f8e43be8b3d988917a1fdc722026cdd587be1629d1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d37e79c73502d787668a26837157ac3cbf673ad47cc63c2c7571cd70a93ad8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14e2492169d85b40c8251c3ca7891c58d35f2f12cd781b720c29582573e12c9a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/grpcurl"
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
