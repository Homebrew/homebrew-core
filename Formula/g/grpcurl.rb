class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://www.fullstory.com/resources/content/fullstory-engineering-blog/"
  license "MIT"
  head "https://github.com/fullstorydev/grpcurl.git", branch: "master"

  stable do
    url "https://github.com/fullstorydev/grpcurl/archive/refs/tags/v1.9.4.tar.gz"
    sha256 "bea899ba2f483a951bf40aa05d41e069dd2f7bfe52d2a229717abfdb5620cb7c"

    # Fix Go 1.27 JSONv2 compatibility
    patch do
      url "https://github.com/fullstorydev/grpcurl/commit/cfa6ff68868284de47db88318a835c00b36d8777.patch?full_index=1"
      sha256 "e4efd7be56266b2665e88e92c4805691b6c540cc1973c786f0e1a922c777d678"
      type :backport
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "847022e00e458ffe5ce4f7a69305ac8096ae718ad2a4e78698237f1be248ad94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "847022e00e458ffe5ce4f7a69305ac8096ae718ad2a4e78698237f1be248ad94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "847022e00e458ffe5ce4f7a69305ac8096ae718ad2a4e78698237f1be248ad94"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "29c80db5f314866f97402a77d7d842e8834ca7bf187bea8ff5bb88ec227b6a93"
    sha256 cellar: :any,                 x86_64_linux:      "05f07ff5a6eee550ad66048d0188c7e892fec3843255a21539d05879ef125e3b"
  end

  depends_on "go" => :build

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
