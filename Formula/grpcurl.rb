class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.3.1.tar.gz"
  sha256 "b856057b7e68e4867ebce18058205554c6317a822eee347a40757d312754311c"

  bottle do
    cellar :any_skip_relocation
    sha256 "857f2535313a36e0394cba3bd609f492fe64e68b18149097153863b68bd5f2c6" => :mojave
    sha256 "f73c21cd3f67f99b14856d6ab83db5d9d117356e9033d0cb288b51579c45a839" => :high_sierra
    sha256 "1449d543680d0e4e925d524df4e42ead5f5733831111df3ba667861c081bfa83" => :sierra
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
