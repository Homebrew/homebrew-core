class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.1.0.tar.gz"
  sha256 "8c8af1643c4d549947a2f2198f5c21d634b2a24b31de975a5784841a9127c82f"

  bottle do
    cellar :any_skip_relocation
    sha256 "5612bb80bcf249efd10d3fb9a09dd99d93746b3ab3550cea68694c5e72114814" => :mojave
    sha256 "e0a8e78d4f67efe3b0a188fd696fa65b666e650d75f5ffe3fc9284dda7fe3899" => :high_sierra
    sha256 "7570834f7fc7289cfa7e04e77dba78edfe5e59d28ec47addeefb92aed1cb9dac" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/fullstorydev/grpcurl").install buildpath.children
    cd "src/github.com/fullstorydev/grpcurl/cmd" do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
             "-o", bin/"grpcurl", "./..."
      prefix.install_metafiles
    end
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
