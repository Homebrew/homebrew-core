class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.5.0.tar.gz"
  sha256 "7bd62197429da0865d88b1a9aa22e7dfac68073e5274bb49d9528787f761f8d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f7f6d9e80f75adfaf051590b1476abb815557ae8db105cd48930618af5203ef" => :catalina
    sha256 "7f46a463a4ccfdd698d5ab95930b8abe3e192269dc4515ac9ffbde9be8a10c7b" => :mojave
    sha256 "39e5de8eef5dc83992ce90b7ede25463fc184065bd2d53e92bcbed60d00d5041" => :high_sierra
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
